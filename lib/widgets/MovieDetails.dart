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
  late Movie _movieDetails;
  final Dio _dio = Dio();
  late TmdbApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    _movie = widget.movie;
    fetchMovieDetails();
    _movieDetails=widget.movie;

  }
  @override
  void didUpdateWidget(covariant MovieDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.movie != oldWidget.movie) {
      _movie = widget.movie;
      fetchMovieDetails();

    }
  }
  String? get directorNames {
    final directors = _movieDetails.credits?.crew
        .where((crewMember) => crewMember.job == "Director")
        .map((director) => director.name)
        .toList();
    return directors?.join(",\n ");
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
                'https://image.tmdb.org/t/p/original/${_movieDetails.backdropPath}',
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
                        'https://image.tmdb.org/t/p/original/${_movieDetails.posterPath}',
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
                            Text("${_movieDetails.releaseDate.split("-").first} | Diretto da:"),
                            SizedBox(height: 10,),
                            Text("${directorNames ?? ''}")
                          ],
                        ),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 80,),
                            Text("${_movieDetails.duration} min")
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
                  'boh',
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
  Future<void> fetchMovieDetails() async {
    try {
      TmdbApiClient _apiClient = TmdbApiClient(Dio());
      _movieDetails = await _apiClient.getMovieDetails(
        apiKey: tmdbApiKey,
        movieId: _movie.id.toString(),
        language: 'it-IT',
        region: 'IT',
        appendToResponse: 'credits',
      );
      final directors = _movieDetails.credits?.crew
          .where((crewMember) => crewMember.job == "Director")
          .map((director) => director.name)
          .toList();
      final directorNames = directors?.join(", ");
      setState(() {
      });
    } catch (error) {
      print('Error fetching top trending movies: $error');
    }
  }
}
