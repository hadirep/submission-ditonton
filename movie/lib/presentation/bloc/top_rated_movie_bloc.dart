import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';
import '../../domain/usecases/get_top_rated_movies.dart';

class TopRatedMovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMovieBloc(this._getTopRatedMovies) : super(Empty()) {
    on<OnMovieChanged>((event, emit) async {
      emit(Loading());
      final result = await _getTopRatedMovies.execute();

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
