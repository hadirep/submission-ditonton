import 'package:core/utils/exception.dart';
import 'package:tv_series/data/datasources/tv_series_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_objects_tv_series.dart';
import '../../../helpers/tv_series/test_helper_tv_series.mocks.dart';

void main() {
  late TVSeriesLocalDataSourceImpl dataSource;
  late MockDatabaseHelperTVSeries mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelperTVSeries();
    dataSource = TVSeriesLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test('should return success message when insert to database is success',
            () async {
          // arrange
          when(mockDatabaseHelper.insertWatchlist(testTVSeriesTable))
              .thenAnswer((_) async => 1);
          // act
          final result = await dataSource.insertWatchlist(testTVSeriesTable);
          // assert
          expect(result, 'Added to Watchlist');
        });

    test('should throw DatabaseException when insert to database is failed',
            () async {
          // arrange
          when(mockDatabaseHelper.insertWatchlist(testTVSeriesTable))
              .thenThrow(Exception());
          // act
          final call = dataSource.insertWatchlist(testTVSeriesTable);
          // assert
          expect(() => call, throwsA(isA<DatabaseException>()));
        });
  });

  group('remove watchlist', () {
    test('should return success message when remove from database is success',
            () async {
          // arrange
          when(mockDatabaseHelper.removeWatchlist(testTVSeriesTable))
              .thenAnswer((_) async => 1);
          // act
          final result = await dataSource.removeWatchlist(testTVSeriesTable);
          // assert
          expect(result, 'Removed from Watchlist');
        });

    test('should throw DatabaseException when remove from database is failed',
            () async {
          // arrange
          when(mockDatabaseHelper.removeWatchlist(testTVSeriesTable))
              .thenThrow(Exception());
          // act
          final call = dataSource.removeWatchlist(testTVSeriesTable);
          // assert
          expect(() => call, throwsA(isA<DatabaseException>()));
        });
  });

  group('Get TV Series Detail By Id', () {
    const tId = 1;

    test('should return TV Series Detail Table when data is found', () async {
      // arrange
      when(mockDatabaseHelper.getTVSeriesById(tId))
          .thenAnswer((_) async => testTVSeriesMap);
      // act
      final result = await dataSource.getTVSeriesById(tId);
      // assert
      expect(result, testTVSeriesTable);
    });

    test('should return null when data is not found', () async {
      // arrange
      when(mockDatabaseHelper.getTVSeriesById(tId)).thenAnswer((_) async => null);
      // act
      final result = await dataSource.getTVSeriesById(tId);
      // assert
      expect(result, null);
    });
  });

  group('get watchlist tv series', () {
    test('should return list of TVSeriesTable from database', () async {
      // arrange
      when(mockDatabaseHelper.getWatchlistTVSeries())
          .thenAnswer((_) async => [testTVSeriesMap]);
      // act
      final result = await dataSource.getWatchlistTVSeries();
      // assert
      expect(result, [testTVSeriesTable]);
    });
  });
}