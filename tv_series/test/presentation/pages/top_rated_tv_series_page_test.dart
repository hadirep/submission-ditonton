import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv_series/presentation/bloc/tv_series_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_state.dart';
import 'package:tv_series/presentation/pages/top_rated_tv_series_page.dart';
import 'package:tv_series/presentation/bloc/top_rated_tv_series_bloc.dart';

import '../../dummy_data/dummy_objects_tv_series.dart';

class TopRatedTVSeriesEventFake extends Fake implements TVSeriesEvent {}
class TopRatedTVSeriesStateFake extends Fake implements TVSeriesState {}
class MockTopRatedTVSeriesBloc extends MockBloc<TVSeriesEvent, TVSeriesState>
    implements TopRatedTVSeriesBloc {}

void main() {
  late MockTopRatedTVSeriesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedTVSeriesEventFake());
    registerFallbackValue(TopRatedTVSeriesStateFake());
  });

  setUp(() {
    mockBloc = MockTopRatedTVSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(Loading());

        final progressFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);

        await tester.pumpWidget(_makeTestableWidget(const TopRatedTVSeriesPage()));

        expect(centerFinder, findsOneWidget);
        expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(HasData([testTVSeries]));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(const TopRatedTVSeriesPage()));

        expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Empty',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(Empty());

        final textFinder = find.text("Top Rated TV Series Not Found");

        await tester.pumpWidget(_makeTestableWidget(const TopRatedTVSeriesPage()));

        expect(textFinder, findsOneWidget);
      });
}
