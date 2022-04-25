import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_series_recommendations.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_detail_notifier.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data_tv_series/dummy_objects.dart';
import 'tv_series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetTVSeriesDetail,
  GetTVSeriesRecommendations,
  GetWatchListStatusTVSeries,
  SaveWatchlistTVSeries,
  RemoveWatchlistTVSeries,
])
void main() {
  late TVSeriesDetailNotifier provider;
  late MockGetTVSeriesDetail mockGetTVSeriesDetail;
  late MockGetTVSeriesRecommendations mockGetTVSeriesRecommendations;
  late MockGetWatchListStatusTVSeries mockGetWatchlistStatus;
  late MockSaveWatchlistTVSeries mockSaveWatchlist;
  late MockRemoveWatchlistTVSeries mockRemoveWatchlist;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetTVSeriesDetail = MockGetTVSeriesDetail();
    mockGetTVSeriesRecommendations = MockGetTVSeriesRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusTVSeries();
    mockSaveWatchlist = MockSaveWatchlistTVSeries();
    mockRemoveWatchlist = MockRemoveWatchlistTVSeries();
    provider = TVSeriesDetailNotifier(
      getTVSeriesDetail: mockGetTVSeriesDetail,
      getTVSeriesRecommendations: mockGetTVSeriesRecommendations,
      getWatchListStatusTVSeries: mockGetWatchlistStatus,
      saveWatchlistTVSeries: mockSaveWatchlist,
      removeWatchlistTVSeries: mockRemoveWatchlist,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

  final tTVSeriess = TVSeries(
    backdropPath: 'backdropPath',
    genreIds: [1, 2],
    id: 1,
    name: 'name',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTVSeries = <TVSeries>[tTVSeriess];

  void _arrangeUsecase() {
    when(mockGetTVSeriesDetail.execute(tId))
        .thenAnswer((_) async => Right(testTVSeriesDetail));
    when(mockGetTVSeriesRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tTVSeries));
  }

  group('Get TV Series Detail', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVSeriesDetail(tId);
      // assert
      verify(mockGetTVSeriesDetail.execute(tId));
      verify(mockGetTVSeriesRecommendations.execute(tId));
    });

    test('should change state to Loading when usecase is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchTVSeriesDetail(tId);
      // assert
      expect(provider.tvSeriesState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change tv series when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVSeriesDetail(tId);
      // assert
      expect(provider.tvSeriesState, RequestState.Loaded);
      expect(provider.tvSeries, testTVSeriesDetail);
      expect(listenerCallCount, 3);
    });

    test('should change recommendation tv series when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVSeriesDetail(tId);
      // assert
      expect(provider.tvSeriesState, RequestState.Loaded);
      expect(provider.tvSeriesRecommendations, tTVSeries);
    });
  });

  group('Get TVSeries Recommendations', () {
    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVSeriesDetail(tId);
      // assert
      verify(mockGetTVSeriesRecommendations.execute(tId));
      expect(provider.tvSeriesRecommendations, tTVSeries);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchTVSeriesDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.tvSeriesRecommendations, tTVSeries);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetTVSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(testTVSeriesDetail));
      when(mockGetTVSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchTVSeriesDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatus.execute(1)).thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatusTVSeries(1);
      // assert
      expect(provider.isAddedToWatchlistTVSeries, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlistTVSeries(testTVSeriesDetail);
      // assert
      verify(mockSaveWatchlist.execute(testTVSeriesDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlist.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlistTVSeries(testTVSeriesDetail);
      // assert
      verify(mockRemoveWatchlist.execute(testTVSeriesDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlistTVSeries(testTVSeriesDetail);
      // assert
      verify(mockGetWatchlistStatus.execute(testTVSeriesDetail.id));
      expect(provider.isAddedToWatchlistTVSeries, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlist.execute(testTVSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatus.execute(testTVSeriesDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlistTVSeries(testTVSeriesDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetTVSeriesDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetTVSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTVSeries));
      // act
      await provider.fetchTVSeriesDetail(tId);
      // assert
      expect(provider.tvSeriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
