import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/utils/utils.dart';
import 'package:tv_series/presentation/widgets/tv_series_card_list.dart';
import '../../bloc/tv_series/watchlist_tv_series_bloc.dart';
import '../../bloc/tv_series/watchlist_tv_series_event.dart';
import '../../bloc/tv_series/watchlist_tv_series_state.dart';

class WatchlistTVSeriesPage extends StatefulWidget {
  static const routeName = '/watchlist-tv-series';

  const WatchlistTVSeriesPage({Key? key}) : super(key: key);

  @override
  _WatchlistTVSeriesPageState createState() => _WatchlistTVSeriesPageState();
}

class _WatchlistTVSeriesPageState extends State<WatchlistTVSeriesPage>
  with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistTVSeriesBloc>().add(WatchlistTVSeries());
  }

  void didChangeDepedencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTVSeriesBloc>().add(WatchlistTVSeries());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTVSeriesBloc, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistHasData) {
              final result = state.result;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<WatchlistTVSeriesBloc>().add(WatchlistTVSeries());
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final tvSeries = result[index];
                    return TVSeriesCard(tvSeries);
                  },
                  itemCount: result.length,
                ),
              );
            } else if (state is WatchlistError) {
              return Text(state.message);
            } else if (state is WatchlistEmpty) {
              return const Text('Watchlist Not Found');
            } else {
              return const Text('Failed');
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}