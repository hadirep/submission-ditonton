import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:movie/movie_injection.dart';
import 'package:search/search.dart';
import 'package:tv_series/tv_series_injection.dart';
import 'package:watchlist/watchlist_injection.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(
        () => SearchMovieBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => SearchTVSeriesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
          () => ListMovieBloc(
        locator(),
      )
  );
  locator.registerFactory(
        () => ListTVSeriesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
          () => PopularMovieBloc(
          locator()
      )
  );
  locator.registerFactory(
        () => PopularTVSeriesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
          () => TopRatedMovieBloc(
          locator()
      )
  );
  locator.registerFactory(
        () => TopRatedTVSeriesBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => DetailMovieBloc(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
        () => DetailTVSeriesBloc(
      locator(),
      locator(),
      locator(),
      locator(),
      locator(),
    ),
  );
  locator.registerFactory(
        () => WatchlistMovieBloc(
      locator(),
    ),
  );
  locator.registerFactory(
        () => WatchlistTVSeriesBloc(
      locator(),
    ),
  );

  // use case movie & tv series
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetNowPlayingTVSeries(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetPopularTVSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedTVSeries(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetTVSeriesDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => GetTVSeriesRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => SearchTVSeries(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusMovie(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTVSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTVSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistMovie(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTVSeries(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetWatchlistTVSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
        () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );
  locator.registerLazySingleton<TVSeriesRepository>(
        () => TVSeriesRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
          () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TVSeriesRemoteDataSource>(
          () => TVSeriesRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
          () => MovieLocalDataSourceImpl(databaseHelper: locator()));
  locator.registerLazySingleton<TVSeriesLocalDataSource>(
          () => TVSeriesLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelperMovie>(() => DatabaseHelperMovie());
  locator.registerLazySingleton<DatabaseHelperTVSeries>(() => DatabaseHelperTVSeries());

  // external
  locator.registerLazySingleton(() => HttpSSLPinning.client);
  locator.registerLazySingleton(() => InternetConnectionChecker());
}