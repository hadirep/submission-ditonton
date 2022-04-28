import 'package:dartz/dartz.dart';
import 'package:watchlist/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_objects_tv_series.dart';
import '../../../helpers/tv_series/test_helper_tv_series.mocks.dart';

void main() {
  late SaveWatchlistTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = SaveWatchlistTVSeries(mockTVSeriesRepository);
  });

  test('should save tv series to the repository', () async {
    // arrange
    when(mockTVSeriesRepository.saveWatchlist(testTVSeriesDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testTVSeriesDetail);
    // assert
    verify(mockTVSeriesRepository.saveWatchlist(testTVSeriesDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
