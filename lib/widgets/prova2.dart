import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';

class HomeApi2 extends StatefulWidget {
  @override
  _HomeApiState2 createState() => _HomeApiState2();
}
class _HomeApiState2 extends State<HomeApi2> {
  final Dio _dio = Dio();
  late TmdbApiClient _apiClient;
  List<Movie>? _topMovies;

  @override
  void initState() {
    super.initState();
    _apiClient = TmdbApiClient(_dio);
    fetchTopMovies();
  }

  Future<void> fetchTopMovies() async {
    try {
      final response = await _apiClient.getTopRatedMovies(tmdbApiKey, 1, 'it', 'IT');
      setState(() {
        _topMovies = response.results.take(3).toList();
      });
    } catch (error) {
      print('Error fetching top movies: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ... Altri widget ...

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
                          'https://image.tmdb.org/t/p/w185/${movie.posterPath}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList() ??
                    [],
              ),
            ),

            // ... Altri widget ...
          ],
        ),
      ),
    );
  }
}
