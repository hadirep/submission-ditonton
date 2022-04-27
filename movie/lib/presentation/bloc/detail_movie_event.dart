import 'package:equatable/equatable.dart';
import '../../domain/entities/movie_detail.dart';

abstract class DetailMovieEvent extends Equatable {
  const DetailMovieEvent();

  @override
  List<Object> get props => [];
}

class OnDetailChanged extends DetailMovieEvent {
  final int id;

  const OnDetailChanged(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlist extends DetailMovieEvent {
  final MovieDetail movieDetail;

  const AddWatchlist(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class RemoveWatchlist extends DetailMovieEvent {
  final MovieDetail movieDetail;

  const RemoveWatchlist(this.movieDetail);

  @override
  List<Object> get props => [movieDetail];
}

class WatchlistStatus extends DetailMovieEvent {
  final int id;

  const WatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}
