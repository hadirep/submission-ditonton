import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tv_series_event.dart';
import '../bloc/tv_series_state.dart';
import '../../domain/usecases/get_now_playing_tv_series.dart';

class ListTVSeriesBloc extends Bloc<TVSeriesEvent, TVSeriesState> {
  final GetNowPlayingTVSeries _getNowPlayingTVSeries;

  ListTVSeriesBloc(this._getNowPlayingTVSeries) : super(Empty()) {
    on<OnTVSeriesChanged>((event, emit) async {
      emit(Loading());
      final result = await _getNowPlayingTVSeries.execute();

      result.fold(
        (failure) {
          emit(Error(failure.message));
        },
        (data) {
          emit(HasData(data));
        },
      );
    });
  }
}
