import 'package:dartz/dartz.dart';
import 'package:watchlist/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../tv_series/test/dummy_data/dummy_objects_tv_series.dart';
import '../../../../../tv_series/test/helpers/test_helper_tv_series.mocks.dart';

void main() {
  late GetWatchlistTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = GetWatchlistTVSeries(mockTVSeriesRepository);
  });

  test('should get list of tv series from the repository', () async {
    // arrange
    when(mockTVSeriesRepository.getWatchlistTVSeries())
        .thenAnswer((_) async => Right(testTVSeriesList));
    // act
    final result = await usecase.execute();
    // assert
    expect(result, Right(testTVSeriesList));
  });
}
