import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/widgets/models/Movie.dart';
import 'package:flutter/material.dart';

import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';

class MovieDetails extends StatefulWidget {
  final Movie movie;

  MovieDetails({required this.movie});

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  late Movie _movie;
  final Dio _dio = Dio();
  late TmdbApiClient _apiClient;
  List<Movie>? _movieNowPlaying;


  @override
  void initState() {
    super.initState();
    _movie = widget.movie;


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.maxFinite,
            height: 270,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(70),
                bottomRight: Radius.circular(70),
              ),
              child: Image.network(
                'https://image.tmdb.org/t/p/original/${_movie.backdropPath}',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                scale: 1.5, // scala dell'ingrandimento
                alignment: Alignment.bottomLeft,
                child: Container(
                  transform: Matrix4.translationValues(10, -10, 0),
                  width: 110,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(
                        'https://image.tmdb.org/t/p/original/${_movie.posterPath}',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Container(
                transform: Matrix4.translationValues(80, 0, 0),
                child:
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${_movie.title}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                          fontFamily: "sans-serif-black"),),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${_movie.releaseDate.split("-").first} | Diretto da:"),
                            SizedBox(height: 10,),


                          ],
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 100,),
                            Text("${_movie.duration}")
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${_movie.releaseDate} | Diretto da',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${_movie.credits?.crew.map((director) => director.name)?.toString() ?? []}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '150 minuti',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.remove_red_eye),
                        label: const Text('Guardato'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite),
                        label: const Text('Preferiti'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.more_time),
                        label: const Text('Watchlist'),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Descrizione',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Descrizione del film',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Future<void> fetchTopTrending() async {
    try {
      final response = await _apiClient.getTrandingMovie(tmdbApiKey, 'it-IT');
      setState(() {
        if (response.results != null) {
          _movieNowPlaying = response.results!.take(6).toList();
          print(_movieNowPlaying?[0].credits);
        } else {
          _movieNowPlaying = [];
        }
      });
    } catch (error) {
      print('Error fetching top trending movies: $error');
    }
  }
}
