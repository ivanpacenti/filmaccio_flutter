import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/main.dart';
import 'package:filmaccio_flutter/widgets/models/Director.dart';
import 'package:filmaccio_flutter/widgets/models/Series.dart';
import 'package:flutter/material.dart';

import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';
import 'models/Character.dart';

class SeriesDetails extends StatefulWidget {
  final Series series;

  SeriesDetails({required this.series});

  @override
  _SeriesDetailsState createState() => _SeriesDetailsState();
}

class _SeriesDetailsState extends State<SeriesDetails> {
  late Series _series;
  late Series _seriesDetails;
  final Dio _dio = Dio();
  late TmdbApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    _series = widget.series;
    fetchSeriesDetails();
    _seriesDetails = widget.series;
  }

  @override
  void didUpdateWidget(covariant SeriesDetails oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.series != oldWidget.series) {
      _series = widget.series;
      fetchSeriesDetails();
    }
  }

  String? get creatorNames {
    final creators = _seriesDetails.creator.map((creator) => creator.name).toList();
    return creators.join(",\n ");
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
                  'https://image.tmdb.org/t/p/original/${_seriesDetails.backdropPath}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.5,
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    transform: Matrix4.translationValues(10, -10, 0),
                    width: 110,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://image.tmdb.org/t/p/original/${_seriesDetails.posterPath}',
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
                        "${_series.title}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                          fontFamily: "sans-serif-black",
                        ),
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
                              Text("${_seriesDetails.releaseDate.split("-").first} | Creato da:"),
                              SizedBox(height: 10),
                              Text("${creatorNames ?? ''}"),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 80,
                              ),
                              Text("${_seriesDetails.duration} min"),
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
                          onPressed: () {},
                          icon: const Icon(Icons.remove_red_eye),
                          label: const Text('Guardato'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite),
                          label: const Text('Preferiti'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.more_time),
                          label: const Text('Watchlist'),
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
                      text: '${_seriesDetails.overview}',
                      maxLines: 3,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'Stagioni',
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
                    itemCount: _seriesDetails.seasons.length,
                    itemBuilder: (context, index) {
                      final season = _seriesDetails.seasons[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeasonDetails(season: season),
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
                                  "https://image.tmdb.org/t/p/w185${season.posterPath}",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Stagione ${season.number}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 200,
                                  child: Text(
                                    '${season.overview}',
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
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
        ),
      ),
    );
  }

  Future<void> fetchSeriesDetails() async {
    try {
      _apiClient = TmdbApiClient(_dio);
      _seriesDetails = await _apiClient.getSeriesDetails(
        apiKey: tmdbApiKey,
        seriesId: _series.id.toString(),
        language: 'it-IT',
        region: 'IT',
        appendToResponse: 'credits',
      );
      setState(() {});
    } catch (error) {
      print('Error fetching series details: $error');
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
