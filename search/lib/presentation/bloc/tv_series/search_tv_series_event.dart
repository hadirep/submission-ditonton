part of 'search_tv_series_bloc.dart';

abstract class SearchTVSeriesEvent extends Equatable {
  const SearchTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class OnTVSeriesQueryChanged extends SearchTVSeriesEvent {
  final String query;

  const OnTVSeriesQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}