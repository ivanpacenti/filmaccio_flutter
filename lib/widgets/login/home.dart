import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/widgets/MovieDetails.dart';
import 'package:filmaccio_flutter/widgets/models/Movie.dart';
import 'package:filmaccio_flutter/widgets/models/TvShow.dart';
import 'package:flutter/material.dart';
import '../Firebase/FirestoreService.dart';
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: item?.posterPath != null
                        ? Image.network(
                      'https://image.tmdb.org/t/p/w185/${item?.posterPath}',
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'assets/images/error_404.png',
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
      final response = await _apiClient.getMovieNowPlaying(tmdbApiKey, 1, 'it-IT', 'IT');
      setState(() {
        if (response.results != null) {
          _movieNowPlaying = response.results.toList();
        } else {
          _movieNowPlaying = [];
        }
      });
    } catch (error) {
      print('Error fetching now playing movies: $error');
    }
  }

  Future<void> fetchTopRating() async {
    try {
      var movies = await FirestoreService.getAllRatings("movies");
      movies.sort((a, b) => b['rating'].compareTo(a['rating']));

      var moviesList = <Movie>[];
      for (var movie in movies) {
        // Assicurati di passare i parametri corretti nella funzione getMovieDetails
        moviesList.add(await _apiClient.getMovieDetails(
            apiKey: tmdbApiKey,
            movieId: movie['id'].toString(),
            language: 'it-IT',
            region: 'IT',
        ));
      }

      setState(() {
        if (moviesList.isNotEmpty) {
          _movieTopRating = moviesList;
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
      var series = await FirestoreService.getAllRatings("series");
      print(series);
      series.sort((a, b) => b['rating'].compareTo(a['rating']));

      var seriesList = <TvShow>[];
      for (var serie in series) {
        // Assicurati di passare i parametri corretti nella funzione getSeriesDetails
        var tvShow = await _apiClient.getTvDetails(
          apiKey: tmdbApiKey,
          serieId: serie['id'].toString(), // anche se sono serie tv, l'id è sempre movieId
          language: 'it-IT',
          region: 'IT',
        );
        print(" le serioe tv sono $tvShow");
        seriesList.add(tvShow);
      }

      setState(() {
        if (seriesList.isNotEmpty) {
          _topRatedTV = seriesList;
        } else {
          _topRatedTV = [];
        }
      });
    } catch (error) {
      print('Error fetching top rated series: $error');
    }
  }

}
