import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'data/api/TmdbApiClient.dart';

class MovieListScreen extends StatefulWidget {
  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  Future<MovieResponse>? _futureMovies;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    final client = TmdbApiClient(dio);
    _futureMovies = client.getPopularMovies('la chiave ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: FutureBuilder<MovieResponse>(
        future: _futureMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data!.results[index].title),
                  // Add more details about the movie here
                );
              },
            );
          }
        },
      ),
    );
  }
}