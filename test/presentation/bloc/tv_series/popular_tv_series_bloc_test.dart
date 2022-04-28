import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_popular_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_event.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_bloc.dart';
import 'package:tv_series/presentation/bloc/tv_series_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTVSeries])
void main() {
  late MockGetPopularTVSeries mockGetPopularTVSeries;
  late PopularTVSeriesBloc popularBloc;

  setUp(() {
    mockGetPopularTVSeries = MockGetPopularTVSeries();
    popularBloc = PopularTVSeriesBloc(mockGetPopularTVSeries);
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

  final tMovieList = <TVSeries>[tTVSeries];
  // Tidak ada data
  test('initial state should be empty', () {
    expect(popularBloc.state, Empty());
  });
  // Ada data
  blocTest<PopularTVSeriesBloc, TVSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockGetPopularTVSeries.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return popularBloc;
    },
    act: (bloc) => bloc.add(OnTVSeriesChanged()),
    expect: () => [
      Loading(),
      HasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockGetPopularTVSeries.execute());
    },
  );
  // Error
  blocTest<PopularTVSeriesBloc, TVSeriesState>(
    'Should emit [Loading, Error] when get popular tv series is unsuccessful',
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
}