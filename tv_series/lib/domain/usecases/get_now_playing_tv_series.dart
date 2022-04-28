import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import '../../domain/entities/tv_series.dart';
import '../../domain/repositories/tv_series_repository.dart';

class GetNowPlayingTVSeries {
  final TVSeriesRepository repository;

  GetNowPlayingTVSeries(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute() {
    return repository.getNowPlayingTVSeries();
  }
}
