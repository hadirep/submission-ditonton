import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/utils/state_enum.dart';
import 'package:watchlist/domain/usecases/tv_series/get_watchlist_status_tv_series.dart';
import 'package:watchlist/domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import 'package:watchlist/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import '../../domain/usecases/get_tv_series_detail.dart';
import '../../domain/usecases/get_tv_series_recommendations.dart';
import '../bloc/detail_tv_series_event.dart';
import '../bloc/detail_tv_series_state.dart';

class DetailTVSeriesBloc extends Bloc<DetailTVSeriesEvent, DetailTVSeriesState> {
  final GetTVSeriesDetail getTVSeriesDetail;
  final GetTVSeriesRecommendations getTVSeriesRecommendations;
  final GetWatchListStatusTVSeries getWatchListStatus;
  final SaveWatchlistTVSeries saveWatchlist;
  final RemoveWatchlistTVSeries removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  DetailTVSeriesBloc(this.getTVSeriesDetail, this.getTVSeriesRecommendations,
      this.getWatchListStatus, this.saveWatchlist,
      this.removeWatchlist) : super(DetailTVSeriesState.initial()) {
        on<OnDetailChanged>(
          (event, emit) async {
          emit(state.copyWith(tvSeriesDetailState: RequestState.loading));
          final result = await getTVSeriesDetail.execute(event.id);
          final recomendationTVSeries = await getTVSeriesRecommendations.execute(event.id);

          result.fold(
                (failure) {
              emit(state.copyWith(
                tvSeriesDetailState: RequestState.error,
                message: failure.message,
              ));
            },
                (detailTVSeries) {
              emit(state.copyWith(
                tvSeriesRecommendationState: RequestState.loading,
                message: '',
                tvSeriesDetailState: RequestState.loaded,
                tvSeriesDetail: detailTVSeries,
              ));
              recomendationTVSeries.fold((failure) {
                emit(state.copyWith(
                  tvSeriesRecommendationState: RequestState.error,
                  message: failure.message,
                ));
              },(recomendations) {
                  emit(state.copyWith(
                  tvSeriesRecommendations: recomendations,
                  tvSeriesRecommendationState: RequestState.loaded,
                  message: '',
                  )
                );
              },
            );
          },
        );
      },
    );
    on<AddWatchlist>(
      (event, emit) async {
        final result = await saveWatchlist.execute(event.tvSeriesDetail);
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
        add(WatchlistStatus(event.tvSeriesDetail.id));
      },
    );
    on<RemoveWatchlist>(
      (event, emit) async {
        final result = await removeWatchlist.execute(event.tvSeriesDetail);
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
        add(WatchlistStatus(event.tvSeriesDetail.id));
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
