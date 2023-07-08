import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/widgets/models/Movie.dart';
import 'package:filmaccio_flutter/widgets/models/TvShow.dart';
import 'package:flutter/material.dart';

import 'MovieDetails.dart';
import 'SeriesDetails.dart';
import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';

// quella che viene chiamata Tendenza

class HomeApi extends StatefulWidget {
  @override
  _HomeApiState createState() => _HomeApiState();
}

class _HomeApiState extends State<HomeApi> {
  final Dio _dio = Dio();
  late TmdbApiClient _apiClient;
  List<Movie>? _topMovies;
  List<Movie>? _topMoviesWeek;
  List<TvShow>? _topTvShows;
  List<TvShow>? _topTrandingTvShows;

  @override
  void initState() {
    super.initState();
    _apiClient = TmdbApiClient(_dio);
    fetchTopMovies();
    fetchTopTvShows();
    fetchTrandingMovie();
    fetchTrandingTvShows();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Film popolari
              buildSection('Film popolari', _topMovies,
                  (movie) => MovieDetails(movie: movie)),
              const Divider(),
              // Serie TV popolari
              buildSection('Serie TV popolari', _topTvShows,
                  (tvShow) => TvShowDetails(tvShow: tvShow)),
              const Divider(),
              // Film di tendenza
              buildSection('Film di tendenza', _topMoviesWeek,
                  (movie) => MovieDetails(movie: movie)),
              const Divider(),
              // Serie TV di tendenza
              buildSection('Serie TV di tendenza', _topTrandingTvShows,
                  (tvShow) => TvShowDetails(tvShow: tvShow)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, List<dynamic>? items,
      Widget Function(dynamic item) detailsBuilder) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items?.length ?? 0,
            itemBuilder: (context, index) {
              final item = items?[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => detailsBuilder(item),
                    ),
                  );
                },
                child: Container(
                  width: 135,
                  margin: const EdgeInsets.only(left: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.grey,
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://image.tmdb.org/t/p/w185/${item?.posterPath}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> fetchTopMovies() async {
    // funzione per prendere i top rated movies
    try {
      final response =
          await _apiClient.getTopRatedMovies(tmdbApiKey, 1, 'it', 'IT');
      setState(() {
        _topMovies = response.results.toList();
      });
    } catch (error) {
      print('Error fetching top movies: $error');
    }
  }

  Future<void> fetchTrandingMovie() async {
    // funzione per prendere i tranding  rated movies
    try {
      final response = await _apiClient.getTrandingMovie(tmdbApiKey, 'IT');
      setState(() {
        _topMoviesWeek = response.results.toList();
      });
    } catch (error) {
      print('Error fetching top trending movies: $error');
    }
  }

  Future<void> fetchTopTvShows() async {
    // funzione per prendere i le serie tv  rated movies
    try {
      final response =
          await _apiClient.getTopRatedTv(tmdbApiKey, 1, 'it', 'IT');
      setState(() {
        if (response.results != null) {
          _topTvShows = response.results!.toList();
        } else {
          _topTvShows = [];
        }
      });
    } catch (error) {
      print('Error fetching top TV shows: $error');
    }
  }

  Future<void> fetchTrandingTvShows() async {
    // funzione per prendere i le serie tv  in tranding
    try {
      final response = await _apiClient.getTrandingTV(tmdbApiKey, 'IT');
      setState(() {
        if (response.results != null) {
          _topTrandingTvShows = response.results.toList();
        } else {
          _topTrandingTvShows = [];
        }
      });
    } catch (error) {
      print('Error fetching top TV shows: $error');
    }
  }
}
