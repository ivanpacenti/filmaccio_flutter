import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/widgets/MovieDetails.dart';
import 'package:filmaccio_flutter/widgets/models/Movie.dart';
import 'package:filmaccio_flutter/widgets/models/TvShow.dart';
import 'package:flutter/material.dart';
import '../data/api/TmdbApiClient.dart';
import '../data/api/api_key.dart';


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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Ultime uscite',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Vedi tutto'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _movieNowPlaying?.length ?? 0,
                itemBuilder: (context, index) {
                  final movie = _movieNowPlaying?[index];
                  return GestureDetector(
                      onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetails(movie: movie!),
                      ),
                    );
                  },
                  child: Container(
                  width: 140,
                  margin: EdgeInsets.only(left: 16.0),
                  decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Colors.grey,
                  image: DecorationImage(
                  image: NetworkImage(
                  'https://image.tmdb.org/t/p/w185/${movie?.posterPath}',
                  ),
                  fit: BoxFit.cover,
                  ),
                  ),
                  ),
                  );},
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Film più votati',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Vedi tutto'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _movieTopRating?.length ?? 0,
                itemBuilder: (context, index) {
                  final movie = _movieTopRating?[index];
                  return Container(
                    width: 140,
                    margin: EdgeInsets.only(left: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w185/${movie?.posterPath}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Serie TV più votate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Vedi tutto'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _topRatedTV?.length ?? 0,
                itemBuilder: (context, index) {
                  final tvShows = _topRatedTV?[index];
                  return Container(
                    width: 140,
                    margin: EdgeInsets.only(left: 16.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.grey,
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/w185/${tvShows?.posterPath}',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchTopTrending() async {
    try {
      final response = await _apiClient.getTrandingMovie(tmdbApiKey, 'it-IT');
      setState(() {
        if (response.results != null) {
          _movieNowPlaying = response.results!.take(6).toList();
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

          _movieTopRating = response.results!.take(6).toList();


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
          _topRatedTV = response.results!.take(6).toList();
        } else {
          _topRatedTV = [];
        }
      });
    } catch (error) {
      print('Error fetching top rated movies: $error');
    }
  }
}
