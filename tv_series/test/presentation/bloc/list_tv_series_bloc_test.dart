import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_now_playing_tv_series.dart';
import 'package:tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_state.dart';
import 'package:tv_series/presentation/bloc/list_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'list_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTVSeries, GetPopularTVSeries, GetTopRatedTVSeries])
void main() {
  late ListTVSeriesBloc listBloc;
  late MockGetNowPlayingTVSeries mockGetNowPlayingTVSeries;
  late PopularTVSeriesBloc popularBloc;
  late MockGetPopularTVSeries mockGetPopularTVSeries;
  late TopRatedTVSeriesBloc topRatedBloc;
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;

  setUp(() {
    mockGetNowPlayingTVSeries = MockGetNowPlayingTVSeries();
    listBloc = ListTVSeriesBloc(mockGetNowPlayingTVSeries);
    mockGetPopularTVSeries = MockGetPopularTVSeries();
    popularBloc = PopularTVSeriesBloc(mockGetPopularTVSeries);
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
    topRatedBloc = TopRatedTVSeriesBloc(mockGetTopRatedTVSeries);
  });

  final tTVSeries = TVSeries(
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );
  final tTVSeriesList = <TVSeries>[tTVSeries];

  group('Now Playing TV Series', () {
    // Tidak ada data
    test('initialState should be Empty', () {
      expect(listBloc.state, Empty());
    });
    //Punya data
    blocTest<ListTVSeriesBloc, TVSeriesState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingTVSeries.execute())
            .thenAnswer((_) async => Right(tTVSeriesList));
        return listBloc;
      },
      act: (bloc) => bloc.add(OnTVSeriesChanged()),
      expect: () => [
        Loading(),
        HasData(tTVSeriesList),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingTVSeries.execute());
      },
    );
    // Error
    blocTest<ListTVSeriesBloc, TVSeriesState>(
      'Should emit [Loading, Error] when get now playing tv series list is unsuccessful',
      build: () {
        when(mockGetNowPlayingTVSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return listBloc;
      },
      act: (bloc) => bloc.add(OnTVSeriesChanged()),
      expect: () => [
        Loading(),
        const Error('Server Failure'),
      ],
      verify: (_) {
        verify(mockGetNowPlayingTVSeries.execute());
      },
    );
  });

  group('Popular TV Series', () {
    // Tidak ada data
    test('initialState should be Empty', () {
      expect(popularBloc.state, Empty());
    });
    //Punya data
    blocTest<PopularTVSeriesBloc, TVSeriesState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetPopularTVSeries.execute())
            .thenAnswer((_) async => Right(tTVSeriesList));
        return popularBloc;
      },
      act: (bloc) => bloc.add(OnTVSeriesChanged()),
      expect: () => [
        Loading(),
        HasData(tTVSeriesList),
      ],
      verify: (bloc) {
        verify(mockGetPopularTVSeries.execute());
      },
    );
    // Error
    blocTest<PopularTVSeriesBloc, TVSeriesState>(
      'Should emit [Loading, Error] when get popular tv series list is unsuccessful',
      build: () {
        when(mockGetPopularTVSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return popularBloc;
      },
      act: (bloc) => bloc.add(OnTVSeriesChanged()),
      expect: () => [
        Loading(),
        const Error('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetPopularTVSeries.execute());
      },
    );
  });

  group('Top Rated TV Series', () {
    // Tidak ada data
    test('initialState should be Empty', () {
      expect(topRatedBloc.state, Empty());
    });
    //Punya data
    blocTest<TopRatedTVSeriesBloc, TVSeriesState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedTVSeries.execute())
            .thenAnswer((_) async => Right(tTVSeriesList));
        return topRatedBloc;
      },
      act: (bloc) => bloc.add(OnTVSeriesChanged()),
      expect: () => [
        Loading(),
        HasData(tTVSeriesList),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTVSeries.execute());
      },
    );
    // Error
    blocTest<TopRatedTVSeriesBloc, TVSeriesState>(
      'Should emit [Loading, Error] when get top rated tv series list is unsuccessful',
      build: () {
        when(mockGetTopRatedTVSeries.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedBloc;
      },
      act: (bloc) => bloc.add(OnTVSeriesChanged()),
      expect: () => [
        Loading(),
        const Error('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedTVSeries.execute());
      },
    );
  });
}
