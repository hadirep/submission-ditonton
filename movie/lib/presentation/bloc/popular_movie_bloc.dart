import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';
import '../../domain/usecases/get_popular_movies.dart';

class PopularMovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetPopularMovies _getPopularMovies;

  PopularMovieBloc(this._getPopularMovies) : super(Empty()) {
    on<OnMovieChanged>((event, emit) async {
      emit(Loading());
      final result = await _getPopularMovies.execute();

      result.fold(
        (failure) {
          emit(Error(failure.message));
        },
        (data) {
          emit(HasData(data));
        },
      );
    });
  }
}
