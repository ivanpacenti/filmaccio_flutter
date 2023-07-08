import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/main.dart';
import 'package:filmaccio_flutter/widgets/models/Movie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Firebase/FirestoreService.dart';
import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';
import 'login/Auth.dart';

class MovieDetails extends StatefulWidget {
  final Movie movie;

  MovieDetails({required this.movie});

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  final User? currentUser = Auth().currentUser;
  final String currentUserId = Auth().currentUser!.uid;
  DocumentSnapshot? userData;
  int? movieMinutes;

  late Movie _movie;
  late Movie _movieDetails;
  final Dio _dio = Dio();
  late TmdbApiClient _apiClient;
  List<dynamic>? filmvisti;

  bool _isWatched = false;
  bool _isFavorite = false;
  bool _isAddedToWatchlist = false;

  Future<void> checkIsWatched() async {
    _isWatched = false;
    filmvisti = await FirestoreService.getList(currentUserId, 'watched_m');
    if (filmvisti != null && filmvisti!.contains(_movieDetails.id)) {
      _isWatched = true;
    }
    setState(() {});
  }

  Future<void> checkisFavorite() async {
    _isFavorite = false;
    filmvisti = await FirestoreService.getList(currentUserId, 'favorite_m');
    if (filmvisti != null && filmvisti!.contains(_movieDetails.id)) {
      _isFavorite = true;
    }
    setState(() {});
  }

  Future<void> ceckisAddedToWatchlist() async {
    _isAddedToWatchlist = false;
    filmvisti = await FirestoreService.getList(currentUserId, 'watchlist_m');
    if (filmvisti != null && filmvisti!.contains(_movieDetails.id)) {
      _isAddedToWatchlist = true;
    }
    setState(() {});
  }

  @override
  // ci vanno le funzione che devono partire all'inizio
  void initState() {
    super.initState();
    _movie = widget.movie;
    fetchMovieDetails();
    _movieDetails = widget.movie;
    checkIsWatched();
    checkisFavorite();
    ceckisAddedToWatchlist();
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
      body: SingleChildScrollView(
          child: Column(
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${_movie.title}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                          fontFamily: "sans-serif-black"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${_movieDetails.releaseDate.split("-").first} | Diretto da:"),
                            SizedBox(
                              height: 10,
                            ),
                            Text("${directorNames ?? ''}")
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 80,
                            ),
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
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            if (_isWatched) {
                              FirestoreService.removeFromList(
                                  currentUserId, 'watched_m', _movieDetails.id);
                              AggiungiMinutes(_movieDetails.duration! * -1);
                              _isWatched = !_isWatched;
                            } else {
                              FirestoreService.addToList(
                                  currentUserId, 'watched_m', _movieDetails.id);
                              AggiungiMinutes(_movieDetails.duration!);
                              _isWatched = !_isWatched;
                            }
                          });
                        },
                        icon: Icon(_isWatched
                            ? Icons.check_box
                            : Icons.check_box_outline_blank),
                        label: Text(_isWatched ? 'Guardato' : 'Guardato',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            if (_isFavorite) {
                              FirestoreService.removeFromList(currentUserId,
                                  'favorite_m', _movieDetails.id);
                              _isFavorite = !_isFavorite;
                            } else {
                              FirestoreService.addToList(currentUserId,
                                  'favorite_m', _movieDetails.id);
                              _isFavorite = !_isFavorite;
                            }
                          });
                        },
                        icon: Icon(_isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border),
                        label: Text(
                            _isFavorite ? 'Preferiti' : 'Aggiungi ai preferiti',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            if (_isAddedToWatchlist) {
                              FirestoreService.removeFromList(currentUserId,
                                  'watchlist_m', _movieDetails.id);
                              _isAddedToWatchlist = !_isAddedToWatchlist;
                              ;
                            } else {
                              FirestoreService.addToList(currentUserId,
                                  'watchlist_m', _movieDetails.id);
                              _isAddedToWatchlist = !_isAddedToWatchlist;
                            }
                          });
                        },
                        icon: Icon(_isAddedToWatchlist
                            ? Icons.playlist_add_check
                            : Icons.playlist_add),
                        label: Text(
                            _isAddedToWatchlist
                                ? 'Watchlist'
                                : 'Aggiungi alla watchlist',
                            style: TextStyle(fontSize: 11)),
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
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(0.1),
                    child: ExpandableText(
                      text: '${_movieDetails.overview}',
                      maxLines: 3,
                    ),
                  )),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Cast',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.transparent),
                width: 500,
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    final castMember = _movieDetails.credits?.cast[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MyApp(),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              transform: Matrix4.translationValues(10, -10, 0),
                              width: 80,
                              height: 80,
                              child: Image.network(
                                "https://image.tmdb.org/t/p/w185${castMember?.profilePath}",
                                fit: BoxFit.contain,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${castMember?.name}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 200, // Larghezza del container
                                  child: Text(
                                    '${castMember?.character}',
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ), // Abilita l'andare a capo
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      )),
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
      print(_movieDetails.credits?.cast.length);

      setState(() {});
    } catch (error) {
      print('Error fetching top trending movies: $error');
    }
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  ExpandableText({required this.text, this.maxLines = 3});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final textSpan = TextSpan(text: widget.text);
        final textPainter = TextPainter(
          text: textSpan,
          maxLines: widget.maxLines,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: constraints.maxWidth);

        final isTextOverflowed = textPainter.didExceedMaxLines;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Text(
                widget.text,
                maxLines: isExpanded ? null : widget.maxLines,
                overflow: TextOverflow.clip,
              ),
            ),
            if (isTextOverflowed)
              TextButton(
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Text(
                  isExpanded ? 'Mostra meno' : 'Mostra altro',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
          ],
        );
      },
    );
  }
}

void myCallback(bool success) {
  if (success) {
    print("Aggiornamento riuscito!");
  } else {
    print("Aggiornamento non riuscito.");
  }
}

void AggiungiMinutes(int minFilm) async {
  final String currentUserId = Auth().currentUser!.uid;
  Map<String, dynamic>? userData;
  userData = await FirestoreService.getUserByUid(currentUserId);
  if (userData != null) {
    var movieMinutes = userData['movieMinutes'] as int?;
    int movieFinale = movieMinutes! +
        minFilm; // Ho cambiato da - a +, dato il nome della funzione "AggiungiMinutes"
    FirestoreService.updateUserField(
            currentUserId, 'movieMinutes', movieFinale, myCallback)
        .catchError((error) => myCallback(false));
  }
}

// Movie convertToMovie(TmdbEntity entity) {
//   return Movie(
//     id: entity.id,
//     title: entity.title,
//     posterPath: entity.imagePath,
//     backdropPath: entity.backdropPath,
//     // Aggiungi qui altri campi se necessario
//
