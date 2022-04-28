import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:core/utils/state_enum.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';
import 'package:movie/presentation/bloc/detail_movie_bloc.dart';
import 'package:movie/presentation/bloc/detail_movie_event.dart';
import 'package:movie/presentation/bloc/detail_movie_state.dart';

import '../../../dummy_data/movie/dummy_objects_movie.dart';

class MovieDetailEventFake extends Fake implements DetailMovieEvent {}
class MovieDetailStateFake extends Fake implements DetailMovieState {}
class MockDetailMovieBloc extends MockBloc<DetailMovieEvent, DetailMovieState>
  implements DetailMovieBloc {}

void main() {
  late MockDetailMovieBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(MovieDetailEventFake());
    registerFallbackValue(MovieDetailEventFake());
  });

  setUp(() {
    mockBloc = MockDetailMovieBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<DetailMovieBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
        DetailMovieState.initial().copyWith(movieDetailState: RequestState.loading));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('should display loading when recommendationState loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
        DetailMovieState.initial().copyWith(
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
          movieRecommendationState: RequestState.loading,
          movieRecommendations: <Movie>[],
          isAddedToWatchlist: false,
    ));

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(progressBarFinder, findsWidgets);
  });

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        DetailMovieState.initial().copyWith(
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
          movieRecommendationState: RequestState.loaded,
          movieRecommendations: [testMovie],
          isAddedToWatchlist: false,
        ));

      final watchlistButtonIcon = find.byIcon(Icons.add);

      await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
    'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        DetailMovieState.initial().copyWith(
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
          movieRecommendationState: RequestState.loaded,
          movieRecommendations: [testMovie],
          isAddedToWatchlist: true,
        )
      );

      final watchlistButtonIcon = find.byIcon(Icons.check);

      await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

      expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([
        DetailMovieState.initial().copyWith(
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
          movieRecommendationState: RequestState.loaded,
          movieRecommendations: [testMovie],
          isAddedToWatchlist: false,
        ),
        DetailMovieState.initial().copyWith(
          movieDetailState: RequestState.loaded,
          movieDetail: testMovieDetail,
          movieRecommendationState: RequestState.loaded,
          movieRecommendations: [testMovie],
          isAddedToWatchlist: false,
          watchlistMessage: 'Added to Watchlist',
        ),
      ]),
      initialState: DetailMovieState.initial());
    final watchlistButton = find.byType(ElevatedButton);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
    'Watchlist button should display Snackbar when removed from watchlist',
    (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          DetailMovieState.initial().copyWith(
            movieDetailState: RequestState.loaded,
            movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.loaded,
            movieRecommendations: [testMovie],
            isAddedToWatchlist: false,
          ),
          DetailMovieState.initial().copyWith(
            movieDetailState: RequestState.loaded,
            movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.loaded,
            movieRecommendations: [testMovie],
            isAddedToWatchlist: false,
            watchlistMessage: 'Removed from Watchlist',
          ),
        ]),
        initialState: DetailMovieState.initial());

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton);
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Removed from Watchlist'), findsOneWidget);
    });

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
      whenListen(
        mockBloc,
        Stream.fromIterable([
          DetailMovieState.initial().copyWith(
            movieDetailState: RequestState.loaded,
            movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.loaded,
            movieRecommendations: [testMovie],
            isAddedToWatchlist: false,
          ),
          DetailMovieState.initial().copyWith(
            movieDetailState: RequestState.loaded,
            movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.loaded,
            movieRecommendations: [testMovie],
            isAddedToWatchlist: false,
            watchlistMessage: 'Failed',
          ),
          DetailMovieState.initial().copyWith(
            movieDetailState: RequestState.loaded,
            movieDetail: testMovieDetail,
            movieRecommendationState: RequestState.loaded,
            movieRecommendations: [testMovie],
            isAddedToWatchlist: false,
            watchlistMessage: 'Failed ',
          ),
        ]),
        initialState: DetailMovieState.initial());

      final watchlistButton = find.byType(ElevatedButton);

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(watchlistButton, warnIfMissed: false);
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    });

  testWidgets(
    'Detail Movie Page should display Error Text when No Internet Network (Error)',
      (WidgetTester tester) async {
      when(() => mockBloc.state).thenReturn(
        DetailMovieState.initial().copyWith(
          movieDetailState: RequestState.error,
          message: 'Failed to connect to the network'
        )
      );

      final textErrorBarFinder = find.text('Failed to connect to the network');

      await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));
      await tester.pump();

      expect(textErrorBarFinder, findsOneWidget);
    });
}
