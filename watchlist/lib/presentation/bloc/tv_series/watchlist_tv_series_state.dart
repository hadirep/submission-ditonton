import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:equatable/equatable.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object> get props => [];
}

class WatchlistEmpty extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistHasData extends WatchlistState {
  final List<TVSeries> result;

  const WatchlistHasData(this.result);

  @override
  List<Object> get props => [result];
}
