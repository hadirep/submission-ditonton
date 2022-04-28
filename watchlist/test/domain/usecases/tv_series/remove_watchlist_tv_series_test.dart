import 'package:dartz/dartz.dart';
import 'package:watchlist/domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../tv_series/test/dummy_data/dummy_objects_tv_series.dart';
import '../../../../../tv_series/test/helpers/test_helper_tv_series.mocks.dart';

void main() {
  late RemoveWatchlistTVSeries usecase;
  late MockTVSeriesRepository mockTVSeriesRepository;

  setUp(() {
    mockTVSeriesRepository = MockTVSeriesRepository();
    usecase = RemoveWatchlistTVSeries(mockTVSeriesRepository);
  });

  test('should remove watchlist tv series from repository', () async {
    // arrange
    when(mockTVSeriesRepository.removeWatchlist(testTVSeriesDetail))
        .thenAnswer((_) async => Right('Removed from watchlist'));
    // act
    final result = await usecase.execute(testTVSeriesDetail);
    // assert
    verify(mockTVSeriesRepository.removeWatchlist(testTVSeriesDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
