import 'package:filmaccio_flutter/widgets/models/Credits.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Movie.g.dart';
@JsonSerializable()
class Movie {
  final int id;
  final String title;
  @JsonKey(name: 'poster_path')
  final String? posterPath;
  //final String overview;
  //@JsonKey(name: 'release_date')
  //final String releaseDate;
  //@JsonKey(name: 'backdrop_path')
  //final String backdropPath;
  //final int runtime;
  //final Credits credits;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    //required this.overview,
    //required this.releaseDate,
    //required this.backdropPath,
    //required this.runtime,
    //required this.credits,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);
}