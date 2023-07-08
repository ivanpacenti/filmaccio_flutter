import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:convert';

import 'MovieDetails.dart';
import 'data/api/TmdbApiClient.dart';
import 'models/Movie.dart';
import 'models/TmdbEntity.dart';
import 'other_user_profile.dart';
import 'data/api/api_key.dart';

class Ricerca extends StatefulWidget {
  @override
  _RicercaState createState() => _RicercaState();
}

class _RicercaState extends State<Ricerca> {
  final Dio _dio = Dio();
  late TmdbApiClient _apiClient;

  final TextEditingController _userSearchController = TextEditingController();
  final TextEditingController _mediaSearchController = TextEditingController();
  Stream<QuerySnapshot>? _usersStream;
  List<TmdbEntity>? _mediaResults;

  void initState() {
    super.initState();
    _apiClient = TmdbApiClient(_dio);
  }

  void _searchUsers() {
    final String searchText = _userSearchController.text.trim();
    if (searchText.isNotEmpty) {
      _usersStream = FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: searchText)
          .where('username', isLessThanOrEqualTo: searchText + '\uf8ff')
          .snapshots();
    } else {
      _usersStream = null;
    }
    setState(() {});
  }

  Future<void> _searchMedia() async {
    final String searchText = _mediaSearchController.text.trim();
    if (searchText.isNotEmpty) {
      final response = await _apiClient.searchMulti(apiKey: tmdbApiKey, query: searchText);
      final results = response.entities;
      setState(() {
        _mediaResults = results;
      });
      print(" i media sono: ${results[0].title}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(16, 80, 16, 0),
              child: Text(
                'Ricerca',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _userSearchController,
                decoration: InputDecoration(
                  hintText: 'Cerca utenti...',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchUsers,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _mediaSearchController,
                decoration: InputDecoration(
                  hintText: 'Cerca serie TV o film...',
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _searchMedia,
                  ),
                ),
              ),
            ),
            Expanded(
              child: _usersStream != null
                  ? StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Errore: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                      String userId = data['uid'];
                      return ListTile(
                        title: Text(data['username']),
                        subtitle: Text(data['nameShown']),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(data['profileImage']),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtherUserProfile(userId),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              )
                  : Container(),
            ),
            Expanded(
              child: _mediaResults != null
                  ? ListView.builder(
                itemCount: _mediaResults!.length,
                itemBuilder: (BuildContext context, int index) {
                  TmdbEntity media = _mediaResults![index];
                  return ListTile(
                    title: Text(media.title),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage('https://image.tmdb.org/t/p/w185/${media.imagePath}'),
                    ),
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => MovieDetails( _mediaResults![index];
                    //       ),
                    //     ),
                    //   );
                    // }
                  );
                },
              )
                  : Container(),
            ),
          ],
      ),
    );
  }
}

// Movie convertToMovie(TmdbEntity entity) {
//   return Movie(
//     id: entity.id,
//     title: entity.title,
//     imagePath: entity.imagePath,
//     mediaType: entity.mediaType,
//     overview: '',
//     releaseDate: '',
//     backdropPath: '',
//     // Aggiungi qui altri campi se necessario
//   );
// }
