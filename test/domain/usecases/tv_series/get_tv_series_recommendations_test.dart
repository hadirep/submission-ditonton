import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_tv_series_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/tv_series/test_helper_tv_series.mocks.dart';

void main() {
  late GetTVSeriesRecommendations usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetTVSeriesRecommendations(mockTVSeriesRepository);
  });

  const tId = 1;
  final tTVSeries = <TVSeries>[];

  test('should get list of tv series recommendations from the repository',
      () async {
    // arrange
    when(mockTVSeriesRepository.getTVSeriesRecommendations(tId))
        .thenAnswer((_) async => Right(tTVSeries));
    // act
    final result = await usecase.execute(tId);
    // assert
    expect(result, Right(tTVSeries));
  });
}
