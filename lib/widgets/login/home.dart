import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/widgets/MovieDetails.dart';
import 'package:filmaccio_flutter/widgets/models/Movie.dart';
import 'package:filmaccio_flutter/widgets/models/TvShow.dart';
import 'package:flutter/material.dart';
import '../data/api/TmdbApiClient.dart';
import '../data/api/api_key.dart';
import '../SeriesDetails.dart';

import 'package:filmaccio_flutter/color_schemes.g.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Dio _dio = Dio();
  late TmdbApiClient _apiClient;
  List<Movie>? _movieNowPlaying;
  List<Movie>? _movieTopRating;
  List<TvShow>? _topRatedTV;

  @override
  void initState() {
    super.initState();
    _apiClient = TmdbApiClient(_dio);
    fetchTopTrending();
    fetchTopRatedTV();
    fetchTopRating();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Ultime uscite
              buildSection('Ultime uscite', _movieNowPlaying, (movie) => MovieDetails(movie: movie)),
              const Divider(),
              // Film più votati
              buildSection('Film più votati', _movieTopRating, (movie) => MovieDetails(movie: movie)),
              const Divider(),
              // Serie TV più votate
              buildSection('Serie TV più votate', _topRatedTV, (tvShow) => TvShowDetails(tvShow: tvShow)),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSection(String title, List<dynamic>? items, Widget Function(dynamic item) detailsBuilder) {
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

  Future<void> fetchTopTrending() async {
    try {
      final response = await _apiClient.getTrandingMovie(tmdbApiKey, 'it-IT');
      setState(() {
        if (response.results != null) {
          _movieNowPlaying = response.results!.toList();
        } else {
          _movieNowPlaying = [];
        }
      });
    } catch (error) {
      print('Error fetching top trending movies: $error');
    }
  }
  Future<void> fetchTopRating() async {
    try {
      final response = await _apiClient.getTopRatedMovies(tmdbApiKey, 1,'it-IT',"IT");
      setState(() {
        if (response.results != null) {

          _movieTopRating = response.results!.toList();


        } else {
          _movieTopRating = [];

        }
      });
    } catch (error) {
      print('Error fetching top rated movies: $error');
    }
  }
  Future<void> fetchTopRatedTV() async {
    try {
      final response = await _apiClient.getTopRatedTv(tmdbApiKey, 6,'it-IT',"IT");
      setState(() {
        if (response.results != null) {
          _topRatedTV = response.results!.toList();
        } else {
          _topRatedTV = [];
        }
      });
    } catch (error) {
      print('Error fetching top rated movies: $error');
    }
  }
}
