import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/domain/entities/tv_series.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/tv_series/search_tv_series.dart';
import 'package:search/presentation/bloc/tv_series/search_tv_series_bloc.dart';

import 'search_bloc_tv_series_test.mocks.dart';

@GenerateMocks([SearchTVSeries])
void main() {
  late SearchTVSeriesBloc searchBloc;
  late MockSearchTVSeries mockSearchTVSeries;

  setUp(() {
    mockSearchTVSeries = MockSearchTVSeries();
    searchBloc = SearchTVSeriesBloc(mockSearchTVSeries);
  });

  final tTVSeriesModel = TVSeries(
    backdropPath: '/rQGBjWNveVeF8f2PGRtS85w9o9r.jpg',
    genreIds: const [18, 9648],
    id: 31917,
    name: 'Pretty Little Liars',
    overview:
    'Based on the Pretty Little Liars series of young adult novels by Sara Shepard, the series follows the lives of four girls — Spencer, Hanna, Aria, and Emily — whose clique falls apart after the disappearance of their queen bee, Alison. One year later, they begin receiving messages from someone using the name \\"A\\" who threatens to expose their secrets — including long-hidden ones they thought only Alison knew.',
    popularity: 47.432451,
    posterPath: '/vC324sdfcS313vh9QXwijLIHPJp.jpg',
    voteAverage: 5.04,
    voteCount: 133,
  );
  final tTVSeriesList = <TVSeries>[tTVSeriesModel];
  const tQuery = 'pretty';

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchTVSeriesEmpty());
  });

  blocTest<SearchTVSeriesBloc, SearchTVSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchTVSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tTVSeriesList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnTVSeriesQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 1200),
    expect: () => [
      SearchTVSeriesLoading(),
      SearchTVSeriesHasData(tTVSeriesList),
    ],
    verify: (bloc) {
      verify(mockSearchTVSeries.execute(tQuery));
    },
  );

  blocTest<SearchTVSeriesBloc, SearchTVSeriesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchTVSeries.execute(tQuery))
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(const OnTVSeriesQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 1200),
    expect: () => [
      SearchTVSeriesLoading(),
      const SearchTVSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchTVSeries.execute(tQuery));
    },
  );
}

