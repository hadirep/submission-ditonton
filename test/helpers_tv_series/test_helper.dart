import 'package:ditonton/data/datasources/db/database_helper_tv_series.dart';
import 'package:ditonton/data/datasources/tv_series_local_data_source.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  TVSeriesRepository,
  TVSeriesRemoteDataSource,
  TVSeriesLocalDataSource,
  DatabaseHelperTVSeries,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
