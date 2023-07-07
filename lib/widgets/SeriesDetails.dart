import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';
import 'models/TvShow.dart';

import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';

class TvShowDetails extends StatefulWidget {
  final TvShow tvShow;

  TvShowDetails({required this.tvShow});

  @override
  _TvShowDetailsState createState() => _TvShowDetailsState();
}

class _TvShowDetailsState extends State<TvShowDetails> {
  late TvShow _tvShow;
  late TvShow _tvShowDetails;
  final Dio _dio = Dio();
  late TmdbApiClient _apiClient;

  bool _isWatched = false;
  bool _isFavorite = false;
  bool _isAddedToWatchlist = false;

  @override
  void initState() {
    super.initState();
    _tvShow = widget.tvShow;
    fetchTvShowDetails();
    _tvShowDetails = widget.tvShow;
  }

  @override
  void didUpdateWidget(covariant TvShowDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tvShow != oldWidget.tvShow) {
      _tvShow = widget.tvShow;
      fetchTvShowDetails();
    }
  }

  String get directorNames {
    final directors = _tvShowDetails.credits?.crew
        .where((crewMember) => crewMember.job == "Director")
        .map((director) => director.name)
        .toList();
    return directors?.join(", ") ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tvShow.name ?? 'No title'),
      ),
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
                  'https://image.tmdb.org/t/p/original/${_tvShowDetails.backdropPath}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isWatched = !_isWatched;
                        });
                      },
                      icon: Icon(
                        _isWatched ? Icons.check_box : Icons.check_box_outline_blank,
                      ),
                      label: Text(_isWatched ? 'Guardato' : 'Da guardare'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isFavorite = !_isFavorite;
                        });
                      },
                      icon: Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                      label: Text(_isFavorite ? 'Preferito' : 'Aggiungi ai preferiti'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isAddedToWatchlist = !_isAddedToWatchlist;
                        });
                      },
                      icon: Icon(
                        _isAddedToWatchlist ? Icons.playlist_add_check : Icons.playlist_add,
                      ),
                      label: Text(_isAddedToWatchlist ? 'Nella watchlist' : 'Aggiungi alla watchlist'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _tvShow.name ?? 'No title',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _tvShowDetails.overview ?? 'No overview available',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Registi:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                directorNames,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            // Aggiungi qui altri dettagli della serie TV che desideri mostrare
          ],
        ),
      ),
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
      );
      setState(() {});
    } catch (error) {
      print('Error fetching TV show details: $error');
    }
  }
}
