import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/utils/state_enum.dart';
import 'package:watchlist/domain/usecases/movie/get_watchlist_status_movie.dart';
import 'package:watchlist/domain/usecases/movie/remove_watchlist_movie.dart';
import 'package:watchlist/domain/usecases/movie/save_watchlist_movie.dart';
import '../../domain/usecases/get_movie_detail.dart';
import '../../domain/usecases/get_movie_recommendations.dart';
import '../bloc/detail_movie_event.dart';
import '../bloc/detail_movie_state.dart';

class DetailMovieBloc extends Bloc<DetailMovieEvent, DetailMovieState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatusMovie getWatchListStatus;
  final SaveWatchlistMovie saveWatchlist;
  final RemoveWatchlistMovie removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  DetailMovieBloc(this.getMovieDetail, this.getMovieRecommendations,
      this.getWatchListStatus, this.saveWatchlist,
      this.removeWatchlist) : super(DetailMovieState.initial()) {
        on<OnDetailChanged>(
          (event, emit) async {
            emit(state.copyWith(movieDetailState: RequestState.loading));
          final result = await getMovieDetail.execute(event.id);
          final recomendationMovie = await getMovieRecommendations.execute(event.id);

          result.fold(
            (failure) {
              emit(state.copyWith(
                movieDetailState: RequestState.error,
                message: failure.message,
              ));
            },
            (detailMovie) {
              emit(state.copyWith(
                movieRecommendationState: RequestState.loading,
                message: '',
                movieDetailState: RequestState.loaded,
                movieDetail: detailMovie,
              ));
            recomendationMovie.fold((failure) {
              emit(state.copyWith(
                movieRecommendationState: RequestState.error,
                message: failure.message,
              ));
            },(recomendations) {
              emit(state.copyWith(
                movieRecommendations: recomendations,
                movieRecommendationState: RequestState.loaded,
                message: '',
              ));
            });
          },
        );
      },
    );
    on<AddWatchlist>(
      (event, emit) async {
        final result = await saveWatchlist.execute(event.movieDetail);
        result.fold(
          (failure) {
            emit(state.copyWith(watchlistMessage: failure.message));
          },
          (added) {
            emit(state.copyWith(
              watchlistMessage: watchlistAddSuccessMessage,
            ));
          },
        );
        add(WatchlistStatus(event.movieDetail.id));
      },
    );
    on<RemoveWatchlist>(
      (event, emit) async {
        final result = await removeWatchlist.execute(event.movieDetail);
        result.fold(
          (failure) {
            emit(state.copyWith(watchlistMessage: failure.message));
          },
          (added) {
            emit(state.copyWith(
              watchlistMessage: watchlistRemoveSuccessMessage,
            ));
          },
        );
        add(WatchlistStatus(event.movieDetail.id));
      },
    );
    on<WatchlistStatus>(
      (event, emit) async {
        final result = await getWatchListStatus.execute(event.id);
        emit(state.copyWith(isAddedToWatchlist: result));
      },
    );
  }
}
