import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/db/database_helper_tv_series.dart';
import 'package:ditonton/data/models/tv_series_table.dart';

abstract class TVSeriesLocalDataSource {
  Future<String> insertWatchlistTVSeries(TVSeriesTable tvSeries);
  Future<String> removeWatchlistTVSeries(TVSeriesTable tvSeries);
  Future<TVSeriesTable?> getTVSeriesById(int id);
  Future<List<TVSeriesTable>> getWatchlistTVSeries();
}

class TVSeriesLocalDataSourceImpl implements TVSeriesLocalDataSource {
  final DatabaseHelperTVSeries databaseHelperTVSeries;

  TVSeriesLocalDataSourceImpl({required this.databaseHelperTVSeries});

  @override
  Future<String> insertWatchlistTVSeries(TVSeriesTable tvSeries) async {
    try {
      await databaseHelperTVSeries.insertWatchlistTVSeries(tvSeries);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlistTVSeries(TVSeriesTable tvSeries) async {
    try {
      await databaseHelperTVSeries.removeWatchlistTVSeries(tvSeries);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<TVSeriesTable?> getTVSeriesById(int id) async {
    final result = await databaseHelperTVSeries.getTVSeriesById(id);
    if (result != null) {
      return TVSeriesTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<TVSeriesTable>> getWatchlistTVSeries() async {
    final result = await databaseHelperTVSeries.getWatchlistTVSeries();
    return result.map((data) => TVSeriesTable.fromMap(data)).toList();
  }
}