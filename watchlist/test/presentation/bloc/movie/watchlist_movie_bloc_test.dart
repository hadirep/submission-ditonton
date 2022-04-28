import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:watchlist/domain/usecases/movie/get_watchlist_movies.dart';
import 'package:watchlist/presentation/bloc/movie/watchlist_movie_bloc.dart';
import 'package:watchlist/presentation/bloc/movie/watchlist_movie_event.dart';
import 'package:watchlist/presentation/bloc/movie/watchlist_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../../movie/test/dummy_data/dummy_objects_movie.dart';
import 'watchlist_movie_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlistMovies])
void main() {
  late WatchlistMovieBloc watchlistBloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistBloc = WatchlistMovieBloc(mockGetWatchlistMovies);
  });

  final tMovies = <Movie>[testMovie];

  test('Initial state should be empty', () {
    expect(watchlistBloc.state, WatchlistEmpty());
  });

  blocTest<WatchlistMovieBloc, WatchlistState>(
    'Should emit [WatchlistLoading, WatchlistHasData] when data is gotten successfully',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => Right(tMovies));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(WatchlistMovie()),
    expect: () => [
      WatchlistLoading(),
      WatchlistHasData(tMovies),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistState>(
    'Should emit [WatchlistLoading, WatchlistHasData[], WatchlistEmpty] when data is empty',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => const Right(<Movie>[]));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(WatchlistMovie()),
    expect: () => [
      WatchlistLoading(),
      const WatchlistHasData(<Movie>[]),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );

  blocTest<WatchlistMovieBloc, WatchlistState>(
    'Should emit [WatchlistLoading, WatchlistError] when data is unsuccessful',
    build: () {
      when(mockGetWatchlistMovies.execute())
          .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(WatchlistMovie()),
    expect: () => [
      WatchlistLoading(),
      const WatchlistError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockGetWatchlistMovies.execute());
    },
  );
}
