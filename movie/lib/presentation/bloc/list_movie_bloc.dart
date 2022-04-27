import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_event.dart';
import '../bloc/movie_state.dart';
import '../../domain/usecases/get_now_playing_movies.dart';

class ListMovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  ListMovieBloc(this._getNowPlayingMovies) : super(Empty()) {
    on<OnMovieChanged>((event, emit) async {
      emit(Loading());
      final result = await _getNowPlayingMovies.execute();

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
