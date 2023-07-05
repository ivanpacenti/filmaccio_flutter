import 'package:filmaccio_flutter/widgets/models/Movie.dart';
import 'package:json_annotation/json_annotation.dart';
part 'DiscoverMoviesResponse.g.dart';

@JsonSerializable()
class DiscoverMoviesResponse {
  List<Movie> results;

  DiscoverMoviesResponse({required this.results});

  factory DiscoverMoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$DiscoverMoviesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoverMoviesResponseToJson(this);
}