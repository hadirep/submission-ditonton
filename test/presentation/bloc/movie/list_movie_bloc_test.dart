import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_now_playing_movies.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/domain/usecases/get_top_rated_movies.dart';
import 'package:movie/presentation/bloc/movie_event.dart';
import 'package:movie/presentation/bloc/movie_state.dart';
import 'package:movie/presentation/bloc/list_movie_bloc.dart';
import 'package:movie/presentation/bloc/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'list_movie_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies, GetPopularMovies, GetTopRatedMovies])
void main() {
  late ListMovieBloc listBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late PopularMovieBloc popularBloc;
  late MockGetPopularMovies mockGetPopularMovies;
  late TopRatedMovieBloc topRatedBloc;
  late MockGetTopRatedMovies mockGetTopRatedMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    listBloc = ListMovieBloc(mockGetNowPlayingMovies);
    mockGetPopularMovies = MockGetPopularMovies();
    popularBloc = PopularMovieBloc(mockGetPopularMovies);
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedBloc = TopRatedMovieBloc(mockGetTopRatedMovies);
  });

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovieList = <Movie>[tMovie];

  group('Now Playing Movies', () {
    // Tidak ada data
    test('initialState should be Empty', () {
      expect(listBloc.state, Empty());
    });
    //Punya data
    blocTest<ListMovieBloc, MovieState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return listBloc;
      },
      act: (bloc) => bloc.add(OnMovieChanged()),
      expect: () => [
        Loading(),
        HasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
    // Error
    blocTest<ListMovieBloc, MovieState>(
      'Should emit [Loading, Error] when get movie list is unsuccessful',
      build: () {
        when(mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return listBloc;
      },
      act: (bloc) => bloc.add(OnMovieChanged()),
      expect: () => [
        Loading(),
        const Error('Server Failure'),
      ],
      verify: (_) {
        verify(mockGetNowPlayingMovies.execute());
      },
    );
  });

  group('Popular Movies', () {
    // Tidak ada data
    test('initialState should be Empty', () {
      expect(popularBloc.state, Empty());
    });
    //Punya data
    blocTest<PopularMovieBloc, MovieState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return popularBloc;
      },
      act: (bloc) => bloc.add(OnMovieChanged()),
      expect: () => [
        Loading(),
        HasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );
    // Error
    blocTest<PopularMovieBloc, MovieState>(
      'Should emit [Loading, Error] when get movie list is unsuccessful',
      build: () {
        when(mockGetPopularMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return popularBloc;
      },
      act: (bloc) => bloc.add(OnMovieChanged()),
      expect: () => [
        Loading(),
        const Error('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetPopularMovies.execute());
      },
    );
  });

  group('Top Rated Movies', () {
    // Tidak ada data
    test('initialState should be Empty', () {
      expect(topRatedBloc.state, Empty());
    });
    //Punya data
    blocTest<TopRatedMovieBloc, MovieState>(
      'Should emit [Loading, HasData] when data is gotten successfully',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return topRatedBloc;
      },
      act: (bloc) => bloc.add(OnMovieChanged()),
      expect: () => [
        Loading(),
        HasData(tMovieList),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
    // Error
    blocTest<TopRatedMovieBloc, MovieState>(
      'Should emit [Loading, Error] when get top rated movie list is unsuccessful',
      build: () {
        when(mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        return topRatedBloc;
      },
      act: (bloc) => bloc.add(OnMovieChanged()),
      expect: () => [
        Loading(),
        const Error('Server Failure'),
      ],
      verify: (bloc) {
        verify(mockGetTopRatedMovies.execute());
      },
    );
  });
}
