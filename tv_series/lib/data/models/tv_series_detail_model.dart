import 'package:equatable/equatable.dart';
import 'package:core/data/models/genre_model.dart';
import '../../domain/entities/tv_series_detail.dart';

class TVSeriesDetailResponse extends Equatable {
  TVSeriesDetailResponse({
    required this.backdropPath,
    required this.genres,
    required this.id,
    required this.name,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  final String? backdropPath;
  final List<GenreModel> genres;
  final int id;
  final String name;
  final String overview;
  final double popularity;
  final String posterPath;
  final double voteAverage;
  final int voteCount;

  factory TVSeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      TVSeriesDetailResponse(
        backdropPath: json["backdrop_path"],
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"] == null ? null : json["poster_path"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
  );

  Map<String, dynamic> toJson() => {
    "backdrop_path": backdropPath,
    "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
    "id": id,
    "name": name,
    "overview": overview,
    "popularity": popularity,
    "poster_path": posterPath,
    "vote_average": voteAverage,
    "vote_count": voteCount,
  };

  TVSeriesDetail toEntity() {
    return TVSeriesDetail(
      backdropPath: this.backdropPath,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      id: this.id,
      name: this.name,
      overview: this.overview,
      popularity: this.popularity,
      posterPath: this.posterPath,
      voteAverage: this.voteAverage,
      voteCount: this.voteCount,
    );
  }

  @override
  List<Object?> get props => [
    backdropPath,
    genres,
    id,
    name,
    overview,
    popularity,
    posterPath,
    voteAverage,
    voteCount,
  ];
}