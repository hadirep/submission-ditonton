import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/presentation/pages/movie/watchlist_movies_page.dart';
import 'package:watchlist/presentation/pages/tv_series/watchlist_tv_series_page.dart';
import 'package:core/utils/routes.dart';
import 'package:core/styles/text_styles.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import '../../domain/entities/tv_series.dart';
import '../bloc/tv_series_event.dart';
import '../bloc/list_tv_series_bloc.dart';
import '../bloc/popular_tv_series_bloc.dart';
import '../bloc/tv_series_state.dart';
import '../bloc/top_rated_tv_series_bloc.dart';
import 'package:search/presentation/pages/tv_series/search_page_tv_series.dart';
import 'tv_series_detail_page.dart';
import 'popular_tv_series_page.dart';
import 'top_rated_tv_series_page.dart';

class HomeTVSeriesPage extends StatefulWidget {
  static const routeName = '/home-tv-series-page';

  const HomeTVSeriesPage({Key? key}) : super(key: key);

  @override
  _HomeTVSeriesPageState createState() => _HomeTVSeriesPageState();
}

class _HomeTVSeriesPageState extends State<HomeTVSeriesPage> {
  @override
  void initState() {
    super.initState();
    super.initState();
    context.read<PopularTVSeriesBloc>().add(OnTVSeriesChanged());
    context.read<TopRatedTVSeriesBloc>().add(OnTVSeriesChanged());
    context.read<ListTVSeriesBloc>().add(OnTVSeriesChanged());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: const Icon(Icons.movie),
              title: const Text('Movies'),
              onTap: () {
                Navigator.pushNamed(context, HomeMoviePage.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.tv_rounded),
              title: const Text('TV Series'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist Movie'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistMoviesPage.routeName);
              },
            ),
            ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Watchlist TV Series'),
              onTap: () {
                Navigator.pushNamed(context, WatchlistTVSeriesPage.routeName);
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, aboutRoute);
              },
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('Ditonton'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchPageTVSeries.routeName);
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing TV Series',
                style: kHeading6,
              ),
              BlocBuilder<ListTVSeriesBloc, TVSeriesState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is HasData) {
                    final result = state.result;
                    return TVSeriesList(result);
                  } else if (state is Error) {
                    final result = state.message;
                    return Text(result);
                  } else if (state is Empty) {
                    return const Text('Now Playing TV Series Not Found');
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Popular TV Series',
                onTap: () =>
                    Navigator.pushNamed(context, PopularTVSeriesPage.routeName),
              ),
              BlocBuilder<PopularTVSeriesBloc, TVSeriesState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is HasData) {
                    final result = state.result;
                    return TVSeriesList(result);
                  } else if (state is Error) {
                    final result = state.message;
                    return Text(result);
                  } else if (state is Empty) {
                    return const Text('Popular TV Series Not Found');
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
              _buildSubHeading(
                title: 'Top Rated TV Series',
                onTap: () =>
                    Navigator.pushNamed(context, TopRatedTVSeriesPage.routeName),
              ),
              BlocBuilder<TopRatedTVSeriesBloc, TVSeriesState>(
                builder: (context, state) {
                  if (state is Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is HasData) {
                    final result = state.result;
                    return TVSeriesList(result);
                  } else if (state is Error) {
                    final result = state.message;
                    return Text(result);
                  } else if (state is Empty) {
                    return const Text('Top Rated TV Series Not Found');
                  } else {
                    return const Text('Failed');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildSubHeading({required String title, required Function() onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: kHeading6,
        ),
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: const [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}

class TVSeriesList extends StatelessWidget {
  final List<TVSeries> tvSeries;

  const TVSeriesList(this.tvSeries, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final tvseries = tvSeries[index];
          return Container(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  TVSeriesDetailPage.routeName,
                  arguments: tvseries.id,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: '$baseUrlimage${tvseries.posterPath}',
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: tvSeries.length,
      ),
    );
  }
}
