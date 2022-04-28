import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../helpers/tv_series/test_helper_tv_series.mocks.dart';

void main() {
  late GetTopRatedTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetTopRatedTVSeries(mockTVSeriesRepository);
  });

  final tTVSeries = <TVSeries>[];

  test('should get list of tv series from repository', () async {
    // arrange
    when(mockTVSeriesRepository.getTopRatedTVSeries())
        .thenAnswer((_) async => Right(tTVSeries));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(tTVSeries));
  });
}
