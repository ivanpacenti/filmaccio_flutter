import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/widgets/data/api/TmdbApiClient.dart';
import 'package:flutter/material.dart';
import 'package:filmaccio_flutter/widgets/Firebase/FirestoreService.dart';
import 'package:filmaccio_flutter/widgets/models/Movie.dart';
import 'package:filmaccio_flutter/widgets/models/DiscoverMoviesResponse.dart';

import 'data/api/api_key.dart';

class HomeApi2 extends StatefulWidget {
  @override
  _HomeApi2State createState() => _HomeApi2State();
}

class _HomeApi2State extends State<HomeApi2> {
  late Future<int> _occurrencesFuture;

  @override
  void initState() {
    super.initState();
    _occurrencesFuture =
        countOccurrences("0okfFM4DpSUp2bQ4IsbOYCtuMok2", "favorite_m");
    getPosters("0okfFM4DpSUp2bQ4IsbOYCtuMok2",
        "favorite_m"); // sostituisci con i tuoi parametri corretti

  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: getPosters("0okfFM4DpSUp2bQ4IsbOYCtuMok2","favorite_m"),
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Errore: ${snapshot.error}');
        } else {
          final posterPaths = snapshot.data ?? [];
          return Row(
            children: posterPaths.map((posterPath) => Container(
              width: 60,
              height: 80,
              child: Image.network(
                posterPath,
                fit: BoxFit.cover,
              ),
            ))
                .toList(),
          );
        }
      },
    );
  }


  Future<int> countOccurrences(String uid, String listName) async {
    List<dynamic> list = await FirestoreService.getList(uid, listName);
    int occurrenceCount = list.length;
    print('Numero totale film preferiti: $occurrenceCount');
    return occurrenceCount;
  }

  Future<List<String>> getPosters(String uid, String listName) async {
    List<dynamic> list = await FirestoreService.getList(uid, listName);
    if (list.isEmpty) {
      print("La lista è vuota");
      print(list[0].toString());
    } else {
      print("La lista non è vuota");
    }
    List<String> posterPaths = [];
    String baseUrl = "https://image.tmdb.org/t/p/w185/";

    TmdbApiClient tmdbApiClient = TmdbApiClient(Dio());

    int maxIndex = (list.length <= 2) ? list.length : 3;
    for (int i = 0; i < maxIndex; i++) {
      String movieId = list[i].toString();
      Movie movieDetails = await tmdbApiClient.getMovieDetails(
        apiKey: tmdbApiKey,
        movieId: movieId,
      );
      if (movieDetails.posterPath != null) {
        String fullPosterPath = "$baseUrl${movieDetails.posterPath}";
        posterPaths.add(fullPosterPath);
      }
    }

    return posterPaths;
  }



}