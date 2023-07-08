import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/widgets/models/Person.dart';
import 'package:filmaccio_flutter/widgets/peopleDetails.dart';
import 'package:flutter/material.dart';

import 'MovieDetails.dart';
import 'SeriesDetails.dart';
import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';
import 'models/Movie.dart';
import 'models/TmdbEntity.dart';
import 'models/TvShow.dart';
import 'other_user_profile.dart';

class Ricerca extends StatefulWidget {
  @override
  _RicercaState createState() => _RicercaState();
}

class _RicercaState extends State<Ricerca> {
  final Dio _dio = Dio();
  late TmdbApiClient _apiClient;

  final TextEditingController _searchController = TextEditingController();
  final List<dynamic> _searchResults = [];

  void initState() {
    super.initState();
    _apiClient = TmdbApiClient(_dio);
  }

  Future<List<DocumentSnapshot>> _searchUsers(String searchText) async {
    if (searchText.isNotEmpty) {
      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: searchText)
          .where('username', isLessThanOrEqualTo: searchText + '\uf8ff')
          .get();
      final userList = userSnapshot.docs;
      print('User Search Results: $userList');
      return userList;
    } else {
      return [];
    }
  }

  Future<List<TmdbEntity>> _searchMedia(String searchText) async {
    List<TmdbEntity> mediaList = [];
    if (searchText.isNotEmpty) {
      final response =
          await _apiClient.searchMulti(apiKey: tmdbApiKey, query: searchText);
      if (response.entities.isNotEmpty) {
        mediaList = response.entities;
      } else {
        mediaList = [];
      }
    }
    return mediaList;
  }

  Future<void> _search() async {
    final String searchText = _searchController.text.trim();
    _searchResults.clear();
    if (searchText.isNotEmpty) {
      final usersFuture = _searchUsers(searchText);
      final mediaFuture = _searchMedia(searchText);

      final results = await Future.wait([usersFuture, mediaFuture]);
      final users = results[0] as List<DocumentSnapshot>;
      final media = results[1] as List<TmdbEntity>;

      _searchResults.addAll(media);
      _searchResults.addAll(users);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 48, 16, 8),
            child: Text(
              'Ricerca',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Ricerca film, serie TV, persone e utenti',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
          ),
          Expanded(
            child: _searchResults.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _searchResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      print('Building item for index $index');
                      final result = _searchResults[index];
                      if (result is TmdbEntity) {
                        // Mostra il media
                        return ListTile(
                          title: Text(result.title),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: result.imagePath != null
                                ? Image.network(
                                    'https://image.tmdb.org/t/p/w185/${result.imagePath}',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/error_404.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          onTap: () {
                            if (result.mediaType == 'tv') {
                              schermatatv(result.id.toString());
                            } else if (result.mediaType == 'movie') {
                              schermatafilm(result.id.toString());
                            } else if (result.mediaType == 'person') {
                              schermataperson(result.id.toString());
                            }
                          },
                        );
                      } else if (result is DocumentSnapshot) {
                        // Mostra l'utente
                        final user = result.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(user['username']),
                          subtitle: Text(user['nameShown']),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(user['profileImage']),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OtherUserProfile(user['uid']),
                              ),
                            );
                          },
                        );
                      } else {
                        return SizedBox.shrink(); // Non dovrebbe mai accadere
                      }
                    },
                  )
                : Container(),
          ),
        ],
      ),
    );
  }

  Future<void> schermatatv(String seriesId) async {
    TvShow tvDetails = await _apiClient.getTvDetails(
      apiKey: tmdbApiKey,
      serieId: seriesId,
      language: 'it-IT',
      region: 'IT',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TvShowDetails(tvShow: tvDetails),
      ),
    );
  }

  Future<void> schermatafilm(String movieId) async {
    Movie movie = await _apiClient.getMovieDetails(
      apiKey: tmdbApiKey,
      movieId: movieId,
      language: 'it-IT',
      region: 'IT',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetails(movie: movie),
      ),
    );
  }

  Future<void> schermataperson(String personId) async {
    Person person = await _apiClient.getPersonDetails(
      apiKey: tmdbApiKey,
      personId: personId,
      language: 'it-IT',
      region: 'IT',
      appendToResponse: 'combined_credits',
    );
    print("PERSONA: " + person.name);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PersonDetailsActivity(person: person),
      ),
    );
  }
}
