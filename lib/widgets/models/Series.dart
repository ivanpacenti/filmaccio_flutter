import 'Character.dart';
import 'Director.dart';

class Series {
  final int id;
  String title;
  final String? posterPath;
  String overview;
  final String releaseDate;
  final String? backdropPath;
  final int duration;
  Credits credits;
  List<Director> creator;
  List<Season> seasons;

  Series({
    required this.id,
    required this.title,
    this.posterPath,
    required this.overview,
    required this.releaseDate,
    this.backdropPath,
    required this.duration,
    required this.credits,
    required this.creator,
    required this.seasons,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id'],
      title: json['name'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      releaseDate: json['first_air_date'],
      backdropPath: json['backdrop_path'],
      duration: json['number_of_episodes'],
      credits: Credits.fromJson(json['credits']),
      creator: List<Director>.from(json['created_by'].map((x) => Director.fromJson(x))),
      seasons: List<Season>.from(json['seasons'].map((x) => Season.fromJson(x))),
    );
  }
}

class Credits {
  List<Character> cast;
  List<Director> crew;

  Credits({
    required this.cast,
    required this.crew,
  });

  factory Credits.fromJson(Map<String, dynamic> json) {
    return Credits(
      cast: List<Character>.from(json['cast'].map((x) => Character.fromJson(x))),
      crew: List<Director>.from(json['crew'].map((x) => Director.fromJson(x))),
    );
  }
}

class Season {
  final int number;
  String? releaseDate;
  String? posterPath;
  String overview;
  List<Episode> episodes;
  String name;

  Season({
    required this.number,
    this.releaseDate,
    this.posterPath,
    required this.overview,
    required this.episodes,
    required this.name,
  });

  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      number: json['season_number'],
      releaseDate: json['air_date'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      episodes: List<Episode>.from(json['episodes'].map((x) => Episode.fromJson(x))),
      name: json['name'],
    );
  }
}

class Episode {
  final int number;
  final int duration;
  final String releaseDate;
  final String? imagePath;
  String overview;
  String name;

  Episode({
    required this.number,
    required this.duration,
    required this.releaseDate,
    this.imagePath,
    required this.overview,
    required this.name,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      number: json['episode_number'],
      duration: json['runtime'],
      releaseDate: json['air_date'],
      imagePath: json['still_path'],
      overview: json['overview'],
      name: json['name'],
    );
  }
}


