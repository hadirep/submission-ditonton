import 'package:dartz/dartz.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/state_enum.dart';
import 'package:core/utils/failure.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:watchlist/domain/usecases/movie/get_watchlist_status_movie.dart';
import 'package:watchlist/domain/usecases/movie/remove_watchlist_movie.dart';
import 'package:watchlist/domain/usecases/movie/save_watchlist_movie.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/presentation/bloc/detail_movie_bloc.dart';
import 'package:movie/presentation/bloc/detail_movie_event.dart';
import 'package:movie/presentation/bloc/detail_movie_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'detail_movie_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatusMovie,
  SaveWatchlistMovie,
  RemoveWatchlistMovie,
])
void main() {
  late DetailMovieBloc detailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListStatusMovie mockGetWatchlistStatus;
  late MockSaveWatchlistMovie mockSaveWatchlist;
  late MockRemoveWatchlistMovie mockRemoveWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchlistStatus = MockGetWatchListStatusMovie();
    mockSaveWatchlist = MockSaveWatchlistMovie();
    mockRemoveWatchlist = MockRemoveWatchlistMovie();
    detailBloc = DetailMovieBloc(
      mockGetMovieDetail,
      mockGetMovieRecommendations,
      mockGetWatchlistStatus,
      mockSaveWatchlist,
      mockRemoveWatchlist,
    );
  });

  const tId = 1;
  final movieDetailStateInit = DetailMovieState.initial();
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
  final tMovies = <Movie>[tMovie];

  final tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [Genre(id: 1, name: 'Comedy')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 1,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  group('Get Movie Detail', () {
    blocTest<DetailMovieBloc, DetailMovieState>(
      'should get data from the usecase',
        build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return detailBloc;
      },
      act: (bloc) => bloc.add(const OnDetailChanged(tId)),
      expect: () => [
        movieDetailStateInit.copyWith(movieDetailState: RequestState.loading),
        movieDetailStateInit.copyWith(
          movieRecommendationState: RequestState.loading,
          movieDetail: tMovieDetail,
          movieDetailState: RequestState.loaded,
          message: '',
        ),
        movieDetailStateInit.copyWith(
          movieDetailState: RequestState.loaded,
          movieDetail: tMovieDetail,
          movieRecommendationState: RequestState.loaded,
          movieRecommendations: tMovies,
          message: '',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );

    blocTest<DetailMovieBloc, DetailMovieState>(
      'should change state to Loading when usecase is called',
      build: () {
        when(mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => Right(tMovieDetail));
        when(mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
        return detailBloc;
      },
      act: (bloc) => bloc.add(const OnDetailChanged(tId)),
      expect: () => [
        movieDetailStateInit.copyWith(movieDetailState: RequestState.loading),
        movieDetailStateInit.copyWith(
          movieRecommendationState: RequestState.loading,
          movieDetail: tMovieDetail,
          movieDetailState: RequestState.loaded,
          message: '',
        ),
        movieDetailStateInit.copyWith(
          movieDetailState: RequestState.loaded,
          movieDetail: tMovieDetail,
          movieRecommendationState: RequestState.error,
          message: 'Failed',
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
      },
    );
  });

  group('AddToWatchlist Movie', () {
    blocTest<DetailMovieBloc, DetailMovieState>(
      'Shoud emit WatchlistMessage and isAddedToWatchlist True when Success AddWatchlist',
      build: () {
        when(mockSaveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(mockGetWatchlistStatus.execute(tMovieDetail.id))
            .thenAnswer((_) async => true);
        return detailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(tMovieDetail)),
      expect: () => [
        movieDetailStateInit.copyWith(watchlistMessage: 'Added to Watchlist'),
        movieDetailStateInit.copyWith(
            watchlistMessage: 'Added to Watchlist', isAddedToWatchlist: true),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchlistStatus.execute(tMovieDetail.id));
      },
    );

    blocTest<DetailMovieBloc, DetailMovieState>(
      'Shoud emit watchlistMessage when Failed',
      build: () {
        when(mockSaveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(tMovieDetail.id))
            .thenAnswer((_) async => false);
        return detailBloc;
      },
      act: (bloc) => bloc.add(AddWatchlist(tMovieDetail)),
      expect: () => [
        movieDetailStateInit.copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockSaveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchlistStatus.execute(tMovieDetail.id));
      },
    );
  });

  group('RemoveFromWatchlist Movie', () {
    blocTest<DetailMovieBloc, DetailMovieState>(
      'Shoud emit watchlistMessage when Failed',
      build: () {
        when(mockRemoveWatchlist.execute(tMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
        when(mockGetWatchlistStatus.execute(tMovieDetail.id))
            .thenAnswer((_) async => false);
        return detailBloc;
      },
      act: (bloc) => bloc.add(RemoveWatchlist(tMovieDetail)),
      expect: () => [
        movieDetailStateInit.copyWith(watchlistMessage: 'Failed'),
      ],
      verify: (_) {
        verify(mockRemoveWatchlist.execute(tMovieDetail));
        verify(mockGetWatchlistStatus.execute(tMovieDetail.id));
      },
    );
  });

  group('LoadWatchlistStatus', () {
    blocTest<DetailMovieBloc, DetailMovieState>(
      'Should Emit AddWatchlistStatus True',
      build: () {
        when(mockGetWatchlistStatus.execute(tId)).thenAnswer((_) async => true);
        return detailBloc;
      },
      act: (bloc) => bloc.add(const WatchlistStatus(tId)),
      expect: () => [
        movieDetailStateInit.copyWith(isAddedToWatchlist: true),
      ],
      verify: (_) {
        verify(mockGetWatchlistStatus.execute(tMovieDetail.id));
      },
    );
  });
}
