import 'package:filmaccio_flutter/widgets/models/TvShow.dart';
import 'package:json_annotation/json_annotation.dart';
part 'DiscoverTvShowsResponse.g.dart';
@JsonSerializable()
class DiscoverTvShowsResponse {
  List<TvShow> results;

  DiscoverTvShowsResponse({required this.results});

  factory DiscoverTvShowsResponse.fromJson(Map<String, dynamic> json) =>
      _$DiscoverTvShowsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoverTvShowsResponseToJson(this);
}