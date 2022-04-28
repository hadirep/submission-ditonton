import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/movie/get_watchlist_movies.dart';
import 'watchlist_movie_event.dart';
import 'watchlist_movie_state.dart';

class WatchlistMovieBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistMovies _getWatchlist;

  WatchlistMovieBloc(this._getWatchlist) : super(WatchlistEmpty()) {
    on<WatchlistMovie>(
      (event, emit) async {
        emit(WatchlistLoading());
        final result = await _getWatchlist.execute();
        result.fold(
          (failure) {
            emit(WatchlistError(failure.message));
          },
          (data) {
            emit(WatchlistHasData(data));
          },
        );
      },
    );
  }
}
