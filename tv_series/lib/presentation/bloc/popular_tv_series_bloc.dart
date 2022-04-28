import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../bloc/tv_series_event.dart';
import '../bloc/tv_series_state.dart';
import '../../domain/usecases/get_popular_tv_series.dart';

class PopularTVSeriesBloc extends Bloc<TVSeriesEvent, TVSeriesState> {
  final GetPopularTVSeries _getPopularTVSeries;

  PopularTVSeriesBloc(this._getPopularTVSeries) : super(Empty()) {
    on<OnTVSeriesChanged>((event, emit) async {
      emit(Loading());
      final result = await _getPopularTVSeries.execute();

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
