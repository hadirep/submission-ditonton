import 'package:equatable/equatable.dart';
import '../../domain/entities/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class Empty extends MovieState {}

class Loading extends MovieState {}

class Error extends MovieState {
  final String message;

  const Error(this.message);

  @override
  List<Object> get props => [message];
}

class HasData extends MovieState {
  final List<Movie> result;

  const HasData(this.result);

  @override
  List<Object> get props => [result];
}