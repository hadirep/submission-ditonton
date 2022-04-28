import 'package:dartz/dartz.dart';
import 'package:watchlist/domain/usecases/movie/save_watchlist_movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../movie/test/dummy_data/dummy_objects_movie.dart';
import '../../../../../movie/test/helpers/test_helper_movie.mocks.dart';

void main() {
  late SaveWatchlistMovie usecase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    usecase = SaveWatchlistMovie(mockMovieRepository);
  });

  test('should save movie to the repository', () async {
    // arrange
    when(mockMovieRepository.saveWatchlist(testMovieDetail))
        .thenAnswer((_) async => Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testMovieDetail);
    // assert
    verify(mockMovieRepository.saveWatchlist(testMovieDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
