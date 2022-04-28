import 'package:equatable/equatable.dart';
import '../../domain/entities/tv_series.dart';

abstract class TVSeriesState extends Equatable {
  const TVSeriesState();

  @override
  List<Object> get props => [];
}

class Empty extends TVSeriesState {}

class Loading extends TVSeriesState {}

class Error extends TVSeriesState {
  final String message;

  const Error(this.message);

  @override
  List<Object> get props => [message];
}

class HasData extends TVSeriesState {
  final List<TVSeries> result;

  const HasData(this.result);

  @override
  List<Object> get props => [result];
}