import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/utils/utils.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';
import '../../bloc/movie/watchlist_movie_bloc.dart';
import '../../bloc/movie/watchlist_movie_event.dart';
import '../../bloc/movie/watchlist_movie_state.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  const WatchlistMoviesPage({Key? key}) : super(key: key);

  @override
  _WatchlistMoviesPageState createState() => _WatchlistMoviesPageState();
}

class _WatchlistMoviesPageState extends State<WatchlistMoviesPage>
  with RouteAware {
  @override
  void initState() {
    super.initState();
    context.read<WatchlistMovieBloc>().add(WatchlistMovie());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(WatchlistMovie());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist Movie'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistMovieBloc, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistHasData) {
              final result = state.result;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<WatchlistMovieBloc>().add(WatchlistMovie());
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final movie = result[index];
                    return MovieCard(movie);
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
