import 'dart:convert';
import 'dart:io';
import 'package:core/utils/exception.dart';
import 'package:tv_series/data/datasources/tv_series_remote_data_source.dart';
import 'package:tv_series/data/models/tv_series_detail_model.dart';
import 'package:tv_series/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../json_reader.dart';
import '../../../helpers/tv_series/test_helper_tv_series.mocks.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TVSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TVSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing TV Series', () {
    final tMovieList = TVSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/now_playing_tv_series.json')))
        .tvSeriesList;

    test('should return list of Movie Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/now_playing_tv_series.json'), 200));
      // act
      final result = await dataSource.getNowPlayingTVSeries();
      // assert
      expect(result, equals(tMovieList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getNowPlayingTVSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular TV Series', () {
    final tTVSeriesList =
        TVSeriesResponse.fromJson(json.decode(readJson('dummy_data/popular_tv_series.json')))
            .tvSeriesList;

    test('should return list of movies when response is success (200)',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/popular_tv_series.json'), 200));
      // act
      final result = await dataSource.getPopularTVSeries();
      // assert
      expect(result, tTVSeriesList);
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getPopularTVSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated TV Series', () {
    final tTVSeriesList = TVSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/top_rated_tv_series.json')))
        .tvSeriesList;

    test('should return list of movies when response code is 200 ', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/top_rated_tv_series.json'), 200));
      // act
      final result = await dataSource.getTopRatedTVSeries();
      // assert
      expect(result, tTVSeriesList);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTopRatedTVSeries();
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv series detail', () {
    const tId = 1;
    final tTVSeriesDetail = TVSeriesDetailResponse.fromJson(
        json.decode(readJson('dummy_data/tv_series_detail.json')));

    test('should return movie detail when the response code is 200', () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async =>
              http.Response(readJson('dummy_data/tv_series_detail.json'), 200));
      // act
      final result = await dataSource.getTVSeriesDetail(tId);
      // assert
      expect(result, equals(tTVSeriesDetail));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTVSeriesDetail(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('get tv series recommendations', () {
    final tTVSeriesList = TVSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/tv_series_recommendations.json')))
        .tvSeriesList;
    const tId = 1;

    test('should return list of Movie Model when the response code is 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/tv_series_recommendations.json'), 200));
      // act
      final result = await dataSource.getTVSeriesRecommendations(tId);
      // assert
      expect(result, equals(tTVSeriesList));
    });

    test('should throw Server Exception when the response code is 404 or other',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.getTVSeriesRecommendations(tId);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });

  group('search tv series', () {
    final tSearchResult = TVSeriesResponse.fromJson(
            json.decode(readJson('dummy_data/search_pretty_little_liars_tv_series.json')))
        .tvSeriesList;
    const query = 'Pretty';

    test('should return list of tv series when response code is 200', () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query')))
          .thenAnswer((_) async => http.Response(
              readJson('dummy_data/search_pretty_little_liars_tv_series.json'), 200,
              headers: {
                HttpHeaders.contentTypeHeader:
                    'application/json; charset=utf-8',
              }));
      // act
      final result = await dataSource.searchTVSeries(query);
      // assert
      expect(result, tSearchResult);
    });

    test('should throw ServerException when response code is other than 200',
        () async {
      // arrange
      when(mockHttpClient
              .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query')))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      // act
      final call = dataSource.searchTVSeries(query);
      // assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
