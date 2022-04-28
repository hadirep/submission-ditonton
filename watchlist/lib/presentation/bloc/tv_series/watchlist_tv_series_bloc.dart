import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'watchlist_tv_series_event.dart';
import 'watchlist_tv_series_state.dart';

class WatchlistTVSeriesBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistTVSeries _getWatchlist;

  WatchlistTVSeriesBloc(this._getWatchlist) : super(WatchlistEmpty()) {
    on<WatchlistTVSeries>(
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
