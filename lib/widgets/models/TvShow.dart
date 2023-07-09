import 'package:json_annotation/json_annotation.dart';

import 'Credits.dart';
import 'Director.dart';

part 'TvShow.g.dart';

@JsonSerializable()
class TvShow {
  final int id;
  String? name;
  @JsonKey(name: 'poster_path')
  String? posterPath;
  final String? overview;
  @JsonKey(name: 'first_air_date')
  final String? releaseDate;
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;
  @JsonKey(name: 'number_of_episodes')
  final int? duration;
  @JsonKey(name: 'credits')
  final Credits? credits;
  @JsonKey(name: 'created_by')
  final List<Director>? creator;

  TvShow({
    required this.id,
    required this.name,
    this.posterPath,
    required this.overview,
    required this.releaseDate,
    required this.backdropPath,
    this.duration,
    this.credits,
    this.creator,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) => _$TvShowFromJson(json);

  Map<String, dynamic> toJson() => _$TvShowToJson(this);
}
