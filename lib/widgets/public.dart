import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/widgets/models/Movie.dart';
import 'package:filmaccio_flutter/widgets/models/TvShow.dart';
import 'package:flutter/material.dart';
import 'MovieDetails.dart';
import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';


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
  List<TvShow>?_topTrandingTvShows;


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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Container(
                margin: EdgeInsets.all(16),
                child: Text(
                  'Film consigliati',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _topMovies?.map((movie) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetails(movie: movie),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: SizedBox(
                        width: 110,
                        height: 165,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w185/${movie.posterPath}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList() ?? [],
              ),
            ),

// QUI INIZIANO I POSTER DELLE SERIE TV
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.all(1),
              child: Text(
                'Serie consigliate',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _topTvShows?.map((tvShow) {
                  return Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: SizedBox(
                      width: 110,
                      height: 165,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w185/${tvShow.posterPath}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList() ?? [],
              ),
            ),

            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.all(16),
              child: Text(
                'Film in tendenza',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),

//qui iniziano i poster dei film in tendenza
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _topMoviesWeek?.map((movie) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MovieDetails(movie: movie),
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: SizedBox(
                        width: 110,
                        height: 165,
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w185/${movie.posterPath}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList() ?? [],
              ),
            ),

            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.all(16),
              child: Text(
                'Serie in tendenza',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _topTrandingTvShows?.map((tvShow) {
                  return Padding(
                    padding: EdgeInsets.only(right: 16.0),
                    child: SizedBox(
                      width: 110,
                      height: 165,
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w185/${tvShow.posterPath}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList() ??
                    [],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }


  Future<void> fetchTopMovies() async {
    // funzione per prendere i top rated movies
    try {
      final response = await _apiClient.getTopRatedMovies(tmdbApiKey, 1, 'it', 'IT');
      setState(() {
        _topMovies = response.results.take(3).toList();
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
        _topMoviesWeek = response.results.take(3).toList();
      });
    } catch (error) {
      print('Error fetching top trending movies: $error');
    }
  }

  Future<void> fetchTopTvShows() async {
    // funzione per prendere i le serie tv  rated movies
    try {
      final response = await _apiClient.getTopRatedTv(tmdbApiKey, 1, 'it', 'IT');
      setState(() {
        if (response.results != null) {
          _topTvShows = response.results!.take(3).toList();
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
          _topTrandingTvShows = response.results!.take(3).toList();
        } else {
          _topTvShows = [];
        }
      });
    } catch (error) {
      print('Error fetching top TV shows: $error');
    }
  }

}