import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:ditonton/data/datasources/movie_local_data_source.dart';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:ditonton/domain/usecases/search_movies.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/popular_movies_notifier.dart';
import 'package:ditonton/presentation/provider/top_rated_movies_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import '../data/datasources/db/database_helper_tv_series.dart';
import '../data/datasources/tv_series_local_data_source.dart';
import '../data/datasources/tv_series_remote_data_source.dart';
import '../data/repositories/tv_series_repository_impl.dart';
import '../domain/repositories/tv_series_repository.dart';
import '../domain/usecases/get_tv_series_detail.dart';
import '../domain/usecases/get_tv_series_recommendations.dart';
import '../domain/usecases/get_now_playing_tv_series.dart';
import '../domain/usecases/get_popular_tv_series.dart';
import '../domain/usecases/get_top_rated_tv_series.dart';
import '../domain/usecases/get_watchlist_tv_series.dart';
import '../domain/usecases/get_watchlist_status_tv_series.dart';
import '../domain/usecases/remove_watchlist_tv_series.dart';
import '../domain/usecases/save_watchlist_tv_series.dart';
import '../domain/usecases/search_tv_series.dart';
import '../presentation/provider/tv_series_detail_notifier.dart';
import '../presentation/provider/tv_series_list_notifier.dart';
import '../presentation/provider/tv_series_search_notifier.dart';
import '../presentation/provider/popular_tv_series_notifier.dart';
import '../presentation/provider/top_rated_tv_series_notifier.dart';
import '../presentation/provider/watchlist_tv_series_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

final locator = GetIt.instance;

void init() {
  // provider movie & tv series
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TVSeriesListNotifier(
      getNowPlayingTVSeries: locator(),
      getPopularTVSeries: locator(),
      getTopRatedTVSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => TVSeriesDetailNotifier(
      getTVSeriesDetail: locator(),
      getTVSeriesRecommendations: locator(),
      getWatchListStatusTVSeries: locator(),
      saveWatchlistTVSeries: locator(),
      removeWatchlistTVSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieSearchNotifier(
      searchMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TVSeriesSearchNotifier(
      searchTVSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => PopularTVSeriesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedTVSeriesNotifier(
      getTopRatedTVSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );
  locator.registerFactory(
     () => WatchlistTVSeriesNotifier(
      getWatchlistTVSeries: locator(),
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
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTVSeries(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTVSeries(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
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
      () => TVSeriesLocalDataSourceImpl(databaseHelperTVSeries: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  locator.registerLazySingleton<DatabaseHelperTVSeries>(() => DatabaseHelperTVSeries());

  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => DataConnectionChecker());
}
