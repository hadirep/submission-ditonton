import 'package:equatable/equatable.dart';

class TVSeries extends Equatable {
  TVSeries({
    required this.backdropPath,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount
  });

  TVSeries.watchlist({
    required this.id,
    required this.overview,
    required this.posterPath,
    required this.name,
  });

  String? backdropPath;
  List<int>? genreIds;
  int id;
  String? name;
  String? overview;
  double? popularity;
  String? posterPath;
  double? voteAverage;
  int? voteCount;

  @override
  List<Object?> get props => [
    backdropPath,
    genreIds,
    id,
    name,
    overview,
    popularity,
    posterPath,
    voteAverage,
    voteCount
  ];
}