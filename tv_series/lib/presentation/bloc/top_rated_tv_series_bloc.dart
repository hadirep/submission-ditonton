import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/tv_series_event.dart';
import '../bloc/tv_series_state.dart';
import '../../domain/usecases/get_top_rated_tv_series.dart';

class TopRatedTVSeriesBloc extends Bloc<TVSeriesEvent, TVSeriesState> {
  final GetTopRatedTVSeries _getTopRatedTVSeries;

  TopRatedTVSeriesBloc(this._getTopRatedTVSeries) : super(Empty()) {
    on<OnTVSeriesChanged>((event, emit) async {
      emit(Loading());
      final result = await _getTopRatedTVSeries.execute();

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
