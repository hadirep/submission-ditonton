import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:core/utils/failure.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:tv_series/domain/usecases/get_top_rated_tv_series.dart';
import 'package:tv_series/presentation/bloc/tv_series_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_state.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'top_rated_tv_series_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTVSeries])
void main() {
  late MockGetTopRatedTVSeries mockGetTopRatedTVSeries;
  late TopRatedTVSeriesBloc topRatedBloc;

  setUp(() {
    mockGetTopRatedTVSeries = MockGetTopRatedTVSeries();
    topRatedBloc = TopRatedTVSeriesBloc(mockGetTopRatedTVSeries);
  });

  final tTVSeries = TVSeries(
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    name:'name',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTVSeriesList = <TVSeries>[tTVSeries];

  test('initial state should be empty', () {
    expect(topRatedBloc.state, Empty());
  });
  // Ada data
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
    'Should emit [Loading, Error] when get top rated tv series is unsuccessful',
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
}
