import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/main.dart';
import 'package:filmaccio_flutter/widgets/models/Movie.dart';
import 'package:filmaccio_flutter/widgets/peopleDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'Firebase/FirestoreService.dart';
import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';
import 'login/Auth.dart';
import 'models/Person.dart';
import 'package:filmaccio_flutter/color_schemes.g.dart';

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

  Future<void> schermataperson(String personId) async {
    Person person = await _apiClient.getPersonDetails(
      apiKey: tmdbApiKey,
      personId: personId,
      language: 'it-IT',
      region: 'IT',
      appendToResponse: 'combined_credits',
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonDetailsActivity(person: person),
      ),
    );
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
    _apiClient = TmdbApiClient(_dio);
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
              child: _movieDetails.backdropPath != null
                  ? Image.network(
                'https://image.tmdb.org/t/p/w780/${_movieDetails.backdropPath}',
                fit: BoxFit.cover,
              )
                  : Image.asset(
                'assets/images/error_404.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16, top: 8),
                width: 120,
                height: 180,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _movieDetails.posterPath != null
                      ? Image.network(
                    'https://image.tmdb.org/t/p/w185/${_movieDetails.posterPath}',
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/images/error_404.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                    child: Text(
                      _movie.title ?? '',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin:
                            const EdgeInsets.only(left: 16, top: 8, right: 16),
                        child: Text(
                            _movieDetails.releaseDate != null ? "${_movieDetails.releaseDate!.split("-").first ?? ''} | Diretto da:" : "Diretto da:",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(left: 16, top: 8, right: 16),
                        child: _movieDetails.duration != null ? Text("${_movieDetails.duration} min",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            )) : null,
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                    child: Text(
                      directorNames ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        fontFeatures: [FontFeature.enable('smcp')],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ))
            ],
          ),
          Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filled(
                            onPressed: () {
                              setState(() {
                                if (_isWatched) {
                                  FirestoreService.removeFromList(currentUserId,
                                      'watched_m', _movieDetails.id);
                                  AggiungiMinutes(_movieDetails.duration! * -1);
                                  _isWatched = !_isWatched;
                                } else {
                                  FirestoreService.addToList(currentUserId,
                                      'watched_m', _movieDetails.id);
                                  AggiungiMinutes(_movieDetails.duration!);
                                  _isWatched = !_isWatched;
                                }
                              });
                            },
                            icon: Icon(_isWatched
                                ? Icons.check
                                : Icons.remove_red_eye),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isWatched
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const Text('Guardato'),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filled(
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
                            icon: Icon(
                                _isFavorite ? Icons.check : Icons.favorite),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isFavorite
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const Text('Preferiti'),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filled(
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
                                ? Icons.check
                                : Icons.more_time_rounded),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isAddedToWatchlist
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const Text('Watchlist'),
                        ]),
                  ])),
          const Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Descrizione',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ExpandableText(
                      text: _movieDetails.overview ?? "Non disponibile",
                      maxLines: 3,
                    ),
                  ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Cast',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(
                width: 500,
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _movieDetails.credits?.cast.length,
                  itemBuilder: (context, index) {
                    final castMember = _movieDetails.credits?.cast[index];
                    return GestureDetector(
                      onTap: () {
                        schermataperson(castMember!.id.toString());
                      },
                      child: Card(
                        child: Container(
                          width: 110,
                          height: 180,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                margin: EdgeInsets.all(5.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: castMember?.profilePath != null ? Image.network(
                                    "https://image.tmdb.org/t/p/w185${castMember?.profilePath}",
                                    fit: BoxFit.cover,
                                  ) : Image.asset(
                                    'assets/images/error_404.png',
                                    fit: BoxFit.cover,
                                  )
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                                child: Text(
                                  '${castMember?.name}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  '${castMember?.character}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ],
                          ),
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
