import 'package:equatable/equatable.dart';
import 'package:core/utils/state_enum.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/entities/tv_series_detail.dart';

class DetailTVSeriesState extends Equatable {
  final TVSeriesDetail? tvSeriesDetail;
  final List<TVSeries> tvSeriesRecommendations;
  final RequestState tvSeriesDetailState;
  final RequestState tvSeriesRecommendationState;
  final String message;
  final String watchlistMessage;
  final bool isAddedToWatchlist;

  const DetailTVSeriesState({
    required this.tvSeriesDetail,
    required this.tvSeriesRecommendations,
    required this.tvSeriesDetailState,
    required this.tvSeriesRecommendationState,
    required this.message,
    required this.watchlistMessage,
    required this.isAddedToWatchlist,
  });

  DetailTVSeriesState copyWith({
    TVSeriesDetail? tvSeriesDetail,
    List<TVSeries>? tvSeriesRecommendations,
    RequestState? tvSeriesDetailState,
    RequestState? tvSeriesRecommendationState,
    String? message,
    String? watchlistMessage,
    bool? isAddedToWatchlist,
  }) {
    return DetailTVSeriesState(
      tvSeriesDetail:
      tvSeriesDetail ?? this.tvSeriesDetail,
      tvSeriesRecommendations:
      tvSeriesRecommendations ?? this.tvSeriesRecommendations,
      tvSeriesDetailState:
      tvSeriesDetailState ?? this.tvSeriesDetailState,
      tvSeriesRecommendationState:
      tvSeriesRecommendationState ?? this.tvSeriesRecommendationState,
      message: message ?? this.message,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
    );
  }

  factory DetailTVSeriesState.initial() {
    return const DetailTVSeriesState(
      tvSeriesDetail: null,
      tvSeriesRecommendations: [],
      tvSeriesDetailState: RequestState.Empty,
      tvSeriesRecommendationState: RequestState.Empty,
      message: '',
      watchlistMessage: '',
      isAddedToWatchlist: false,
    );
  }

  @override
  List<Object?> get props => [
    tvSeriesDetail,
    tvSeriesRecommendations,
    tvSeriesDetailState,
    tvSeriesRecommendationState,
    message,
    watchlistMessage,
    isAddedToWatchlist,
  ];
}

