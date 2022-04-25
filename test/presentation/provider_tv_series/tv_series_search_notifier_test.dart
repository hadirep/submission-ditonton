import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:ditonton/presentation/provider/tv_series_search_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'tv_series_search_notifier_test.mocks.dart';

@GenerateMocks([SearchTVSeries])
void main() {
  late TVSeriesSearchNotifier provider;
  late MockSearchTVSeries mockSearchTVSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockSearchTVSeries = MockSearchTVSeries();
    provider = TVSeriesSearchNotifier(searchTVSeries: mockSearchTVSeries)
      ..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tTVSeriesModel = TVSeries(
    backdropPath: '/rQGBjWNveVeF8f2PGRtS85w9o9r.jpg',
    genreIds: [18, 9648],
    id: 31917,
    name: 'Pretty Little Liars',
    overview:
    'Based on the Pretty Little Liars series of young adult novels by Sara Shepard, the series follows the lives of four girls — Spencer, Hanna, Aria, and Emily — whose clique falls apart after the disappearance of their queen bee, Alison. One year later, they begin receiving messages from someone using the name \\\"A\\\" who threatens to expose their secrets — including long-hidden ones they thought only Alison knew.',
    popularity: 47.432451,
    posterPath: '/vC324sdfcS313vh9QXwijLIHPJp.jpg',
    voteAverage: 5.04,
    voteCount: 133,
  );
  final tMovieList = <TVSeries>[tTVSeriesModel];
  final tQuery = 'pretty';

  group('search tv series', () {
    test('should change state to loading when usecase is called', () async {
      // arrange
      when(mockSearchTVSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      provider.fetchTVSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loading);
    });

    test('should change search result data when data is gotten successfully',
        () async {
      // arrange
      when(mockSearchTVSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tMovieList));
      // act
      await provider.fetchTVSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Loaded);
      expect(provider.searchResult, tMovieList);
      expect(listenerCallCount, 2);
    });

    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockSearchTVSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      // act
      await provider.fetchTVSeriesSearch(tQuery);
      // assert
      expect(provider.state, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
