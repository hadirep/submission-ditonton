import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:tv_series/presentation/bloc/tv_series_event.dart';
import 'package:tv_series/presentation/bloc/tv_series_state.dart';
import 'package:tv_series/presentation/pages/popular_tv_series_page.dart';
import 'package:tv_series/presentation/bloc/popular_tv_series_bloc.dart';

import '../../../dummy_data/tv_series/dummy_objects_tv_series.dart';

class PopularTVSeriesEventFake extends Fake implements TVSeriesEvent {}
class PopularTVSeriesStateFake extends Fake implements TVSeriesState {}
class MockPopularTVSeriesBloc extends MockBloc<TVSeriesEvent, TVSeriesState>
    implements PopularTVSeriesBloc {}

void main() {
  late MockPopularTVSeriesBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(PopularTVSeriesEventFake());
    registerFallbackValue(PopularTVSeriesStateFake());
  });

  setUp(() {
    mockBloc = MockPopularTVSeriesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularTVSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(Loading());
        final progressBarFinder = find.byType(CircularProgressIndicator);
        final centerFinder = find.byType(Center);
        await tester.pumpWidget(_makeTestableWidget(const PopularTVSeriesPage()));
        expect(centerFinder, findsOneWidget);
        expect(progressBarFinder, findsOneWidget);
      });

  testWidgets('Page should display ListView when data is loaded',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(HasData([testTVSeries]));

        final listViewFinder = find.byType(ListView);

        await tester.pumpWidget(_makeTestableWidget(const PopularTVSeriesPage()));

        expect(listViewFinder, findsOneWidget);
      });

  testWidgets('Page should display text with message when Empty',
          (WidgetTester tester) async {
        when(() => mockBloc.state).thenReturn(Empty());

        final textFinder = find.text("Popular TV Series Not Found");

        await tester.pumpWidget(_makeTestableWidget(const PopularTVSeriesPage()));

        expect(textFinder, findsOneWidget);
      });
}
