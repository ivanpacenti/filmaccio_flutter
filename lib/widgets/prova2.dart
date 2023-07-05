import 'package:dio/dio.dart';
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
  List<Movie>? _topTvShows;

  @override
  void initState() {
    super.initState();
    _apiClient = TmdbApiClient(_dio);
    fetchTopTvShows();
  }

  Future<void> fetchTopTvShows() async {
    try {
      final response = await _apiClient.getTopRatedTv(tmdbApiKey, 1, 'it', 'IT');
      setState(() {
        _topTvShows = response.results.take(3).toList();
      });
    } catch (error) {
      print('Error fetching top TV shows: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.all(16),
              child: Text(
                'Serie consigliate',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _topTvShows?.map((tvShow) {
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
                          'https://image.tmdb.org/t/p/w185/${tvShow.posterPath}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList() ??
                    [],
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
