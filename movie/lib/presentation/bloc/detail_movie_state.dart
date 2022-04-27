import 'package:equatable/equatable.dart';
import 'package:core/utils/state_enum.dart';
import '../../domain/entities/movie.dart';
import '../../domain/entities/movie_detail.dart';

class DetailMovieState extends Equatable {
  final MovieDetail? movieDetail;
  final List<Movie> movieRecommendations;
  final RequestState movieDetailState;
  final RequestState movieRecommendationState;
  final String message;
  final String watchlistMessage;
  final bool isAddedToWatchlist;

  const DetailMovieState({
    required this.movieDetail,
    required this.movieRecommendations,
    required this.movieDetailState,
    required this.movieRecommendationState,
    required this.message,
    required this.watchlistMessage,
    required this.isAddedToWatchlist,
  });

  DetailMovieState copyWith({
    MovieDetail? movieDetail,
    List<Movie>? movieRecommendations,
    RequestState? movieDetailState,
    RequestState? movieRecommendationState,
    String? message,
    String? watchlistMessage,
    bool? isAddedToWatchlist,
  }) {
    return DetailMovieState(
      movieDetail:
        movieDetail ?? this.movieDetail,
      movieRecommendations:
        movieRecommendations ?? this.movieRecommendations,
      movieDetailState:
        movieDetailState ?? this.movieDetailState,
      movieRecommendationState:
        movieRecommendationState ?? this.movieRecommendationState,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  factory DetailMovieState.initial() {
    return DetailMovieState(
      movieDetail: null,
      movieRecommendations: [],
      movieDetailState: RequestState.Empty,
      movieRecommendationState: RequestState.Empty,
      message: '',
      watchlistMessage: '',
      isAddedToWatchlist: false,
    );
  }

  @override
  List<Object?> get props => [
    movieDetail,
    movieRecommendations,
    movieDetailState,
    movieRecommendationState,
    message,
    watchlistMessage,
    isAddedToWatchlist,
  ];
}

