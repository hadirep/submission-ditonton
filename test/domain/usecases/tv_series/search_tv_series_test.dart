import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:search/domain/usecases/tv_series/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/tv_series/test_helper_tv_series.mocks.dart';

void main() {
  late SearchTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = SearchTVSeries(mockTVSeriesRepository);
  });

  final tTVSeries = <TVSeries>[];
  const tQuery = 'Pretty';

  test('should get list of movies from the repository', () async {
    // arrange
    when(mockTVSeriesRepository.searchTVSeries(tQuery))
        .thenAnswer((_) async => Right(tTVSeries));
    // act
    final result = await usecase.execute(tQuery);
    // assert
    expect(result, Right(tTVSeries));
  });
}
