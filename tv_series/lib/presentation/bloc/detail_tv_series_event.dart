import 'package:equatable/equatable.dart';
import '../../domain/entities/tv_series_detail.dart';

abstract class DetailTVSeriesEvent extends Equatable {
  const DetailTVSeriesEvent();

  @override
  List<Object> get props => [];
}

class OnDetailChanged extends DetailTVSeriesEvent {
  final int id;

  const OnDetailChanged(this.id);

  @override
  List<Object> get props => [id];
}

class AddWatchlist extends DetailTVSeriesEvent {
  final TVSeriesDetail tvSeriesDetail;

  const AddWatchlist(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}

class RemoveWatchlist extends DetailTVSeriesEvent {
  final TVSeriesDetail tvSeriesDetail;

  const RemoveWatchlist(this.tvSeriesDetail);

  @override
  List<Object> get props => [tvSeriesDetail];
}

class WatchlistStatus extends DetailTVSeriesEvent {
  final int id;

  const WatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}
