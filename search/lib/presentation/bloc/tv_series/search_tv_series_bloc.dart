import 'package:bloc/bloc.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import '../../../domain/usecases/tv_series/search_tv_series.dart';
part 'search_tv_series_event.dart';
part 'search_tv_series_state.dart';

class SearchTVSeriesBloc extends Bloc<SearchTVSeriesEvent, SearchTVSeriesState> {
  final SearchTVSeries _searchTVSeries;

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  SearchTVSeriesBloc(this._searchTVSeries) : super(SearchTVSeriesEmpty()) {
    on<OnTVSeriesQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchTVSeriesLoading());
      final resultTVSeries = await _searchTVSeries.execute(query);

      resultTVSeries.fold(
            (failure) {
          emit(SearchTVSeriesError(failure.message));
        },
            (data) {
          emit(SearchTVSeriesHasData(data));
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }
}
