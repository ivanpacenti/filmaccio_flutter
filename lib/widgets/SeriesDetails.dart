import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/widgets/peopleDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Firebase/FirestoreService.dart';
import 'MovieDetails.dart';
import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';
import 'login/Auth.dart';
import 'models/Person.dart';
import 'models/TvShow.dart';

/// classe per il dettaglio delle serie tv
/// @autor NicolaPiccia
/// @autor {nicolobartolinii}
class TvShowDetails extends StatefulWidget {
  final TvShow tvShow;

  TvShowDetails({required this.tvShow});

  @override
  _TvShowDetailsState createState() => _TvShowDetailsState();
}

class _TvShowDetailsState extends State<TvShowDetails> {
  final User? currentUser = Auth().currentUser;
  final String currentUserId = Auth().currentUser!.uid;
  DocumentSnapshot? userData;
  int? movieMinutes;

  late TvShow _tvShow;
  late TvShow _tvShowDetails;
  final Dio _dio = Dio();
  late TmdbApiClient _apiClient;
  List<dynamic>? seriesSeen;

  bool _isWatching = false;
  bool _isFinished = false;
  bool _isFavorite = false;
  bool _isAddedToWatchlist = false;

  Future<void> checkIsWatching() async {
    _isWatching = false;
    seriesSeen = await FirestoreService.getList(currentUserId, 'watching_t');
    if (seriesSeen != null && seriesSeen!.contains(_tvShowDetails.id)) {
      _isWatching = true;
    }
    setState(() {});
  }

  Future<void> checkIsFinished() async {
    _isFinished = false;
    seriesSeen = await FirestoreService.getList(currentUserId, 'finished_t');
    if (seriesSeen != null && seriesSeen!.contains(_tvShowDetails.id)) {
      _isFinished = true;
    }
  }

  Future<void> schermataperson(String personId) async {
    // cambiamento dal solito metodo a casusa della natura asincrona delle gunzioni async, lo statp del BuildContext potrebbe non essere più valido prima che sia c
    //completata la funzione, e si potrebbero creare errori
    Person person = await _apiClient.getPersonDetails(
      apiKey: tmdbApiKey,
      personId: personId,
      language: 'it-IT',
      region: 'IT',
      appendToResponse: 'combined_credits',
    );
    if(mounted){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PersonDetailsActivity(person: person),
        ),
      );
    }
  }


  Future<void> checkisFavorite() async {
    _isFavorite = false;
    seriesSeen = await FirestoreService.getList(currentUserId, 'favorite_t');
    if (seriesSeen != null && seriesSeen!.contains(_tvShowDetails.id)) {
      _isFavorite = true;
    }
    setState(() {});
  }

  Future<void> ceckisAddedToWatchlist() async {
    _isAddedToWatchlist = false;
    seriesSeen = await FirestoreService.getList(currentUserId, 'watchlist_t');
    if (seriesSeen != null && seriesSeen!.contains(_tvShowDetails.id)) {
      _isAddedToWatchlist = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _apiClient = TmdbApiClient(_dio);
    _tvShow = widget.tvShow;
    fetchTvShowDetails();
    _tvShowDetails = widget.tvShow;
    checkIsWatching();
    checkIsFinished();
    checkisFavorite();
    ceckisAddedToWatchlist();
  }

  @override
  void didUpdateWidget(covariant TvShowDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tvShow != oldWidget.tvShow) {
      _tvShow = widget.tvShow;
      fetchTvShowDetails();
    }
  }

  String? get directorNames {
    if (_tvShowDetails.creator != null) {
      final directors =
          _tvShowDetails.creator?.map((director) => director.name).toList();
      return directors?.join(", ");
    } else {
      final directors = _tvShowDetails.credits?.crew
          .where((crewMember) =>
              crewMember.job == "Creator" ||
              crewMember.job == "Series Director")
          .map((director) => director.name)
          .toList();
      return directors?.join(", ");
    }
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
              child: _tvShowDetails.backdropPath != null
                  ? Image.network(
                      'https://image.tmdb.org/t/p/w780/${_tvShowDetails.backdropPath}',
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
                  child: _tvShowDetails.posterPath != null
                      ? Image.network(
                          'https://image.tmdb.org/t/p/w185/${_tvShowDetails.posterPath}',
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
                      _tvShowDetails.name ?? '',
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
                            _tvShowDetails.releaseDate != null
                                ? "${_tvShowDetails.releaseDate!.split("-").first ?? ''} | Diretto da:"
                                : "Diretto da:",
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
                        child: _tvShowDetails.duration != null
                            ? Text("${_tvShowDetails.duration} ep.",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ))
                            : null,
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                    child: Text(
                      directorNames == ''
                          ? 'Non disponibile'
                          : directorNames ?? 'Non disponibile',
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
                                if (_isFinished) {
                                  return;
                                } else if (_isWatching) {
                                  FirestoreService.removeFromList(currentUserId,
                                      'watching_t', _tvShowDetails.id);
                                  _isWatching = !_isWatching;
                                } else {
                                  FirestoreService.addToList(currentUserId,
                                      'watching_t', _tvShowDetails.id);
                                  _isWatching = !_isWatching;
                                }
                              });
                            },
                            icon: Icon(_isFinished
                                ? Icons.check
                                : _isWatching
                                    ? Icons.play_circle_outline_rounded
                                    : Icons.remove_red_eye),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isFinished || _isWatching
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          _isFinished
                              ? const Text('Completata')
                              : const Text('In visione'),
                        ]),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton.filled(
                            onPressed: () {
                              setState(() {
                                if (_isFavorite) {
                                  FirestoreService.removeFromList(currentUserId,
                                      'favorite_t', _tvShowDetails.id);
                                  _isFavorite = !_isFavorite;
                                } else {
                                  FirestoreService.addToList(currentUserId,
                                      'favorite_t', _tvShowDetails.id);
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
                                      'watchlist_t', _tvShowDetails.id);
                                  _isAddedToWatchlist = !_isAddedToWatchlist;
                                  ;
                                } else {
                                  FirestoreService.addToList(currentUserId,
                                      'watchlist_t', _tvShowDetails.id);
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpandableText(
                  text: _tvShowDetails.overview ?? "Non disponibile",
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 11),
                child: SizedBox(
                  width: 500,
                  height: 190,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tvShowDetails.credits?.cast.length,
                    itemBuilder: (context, index) {
                      final castMember = _tvShowDetails.credits?.cast[index];
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
                                      child: castMember?.profilePath != null
                                          ? Image.network(
                                              "https://image.tmdb.org/t/p/w185${castMember?.profilePath}",
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/images/error_404.png',
                                              fit: BoxFit.cover,
                                            )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 5.0),
                                  child: Text(
                                    '${castMember?.name}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    '${castMember?.character}',
                                    style: const TextStyle(
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
              )
            ],
          ),
        ],
      )),
    );
  }

  Future<void> fetchTvShowDetails() async {
    try {
      _apiClient = TmdbApiClient(_dio);
      _tvShowDetails = await _apiClient.getTvDetails(
        apiKey: tmdbApiKey,
        serieId: _tvShow.id.toString(),
        language: 'it-IT',
        region: 'IT',
        appendToResponse: 'credits',
      );
      setState(() {});
    } catch (error) {
      print('Error fetching TV show details: $error');
    }
  }
}
