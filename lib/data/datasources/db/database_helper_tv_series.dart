import 'dart:async';

import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelperTVSeries {
  static DatabaseHelperTVSeries? _databaseHelper;
  DatabaseHelperTVSeries._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelperTVSeries() => _databaseHelper ?? DatabaseHelperTVSeries._instance();

  static Database? _database;

  Future<Database?> get databaseTVSeries async {
    if (_database == null) {
      _database = await _initDb();
    }
    return _database;
  }

  static const String _tblWatchlistTVSeries = 'watchlistTVSeries';

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = '$path/ditontontvseries.db';

    var db = await openDatabase(databasePath, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE  $_tblWatchlistTVSeries (
        id INTEGER PRIMARY KEY,
        name TEXT,
        overview TEXT,
        posterPath TEXT
      );
    ''');
  }

  Future<int> insertWatchlistTVSeries(TVSeriesTable tvSeries) async {
    final db = await databaseTVSeries;
    return await db!.insert(_tblWatchlistTVSeries, tvSeries.toJson());
  }

  Future<int> removeWatchlistTVSeries(TVSeriesTable tvSeries) async {
    final db = await databaseTVSeries;
    return await db!.delete(
      _tblWatchlistTVSeries,
      where: 'id = ?',
      whereArgs: [tvSeries.id],
    );
  }

  Future<Map<String, dynamic>?> getTVSeriesById(int id) async {
    final db = await databaseTVSeries;
    final results = await db!.query(
      _tblWatchlistTVSeries,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getWatchlistTVSeries() async {
    final db = await databaseTVSeries;
    final List<Map<String, dynamic>> results = await db!.query(_tblWatchlistTVSeries);

    return results;
  }
}
