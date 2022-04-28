import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/tv_series_card_list.dart';
import '../bloc/tv_series_state.dart';
import '../bloc/tv_series_event.dart';
import '../bloc/popular_tv_series_bloc.dart';

class PopularTVSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv-series-page';

  const PopularTVSeriesPage({Key? key}) : super(key: key);

  @override
  _PopularTVSeriesPageState createState() => _PopularTVSeriesPageState();
}

class _PopularTVSeriesPageState extends State<PopularTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    context.read<PopularTVSeriesBloc>().add(OnTVSeriesChanged());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTVSeriesBloc, TVSeriesState>(
          builder: (context, state) {
            if (state is Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is HasData) {
              final result = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tvSeries = result[index];
                  return TVSeriesCard(tvSeries);
                },
                itemCount: result.length,
              );
            } else if (state is Error) {
              return Text(state.message);
            } else if (state is Empty) {
              return const Text('Popular TV Series Not Found');
            } else {
              return const Text('Failed');
            }
          },
        ),
      ),
    );
  }
}