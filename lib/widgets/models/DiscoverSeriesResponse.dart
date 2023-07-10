import 'package:filmaccio_flutter/widgets/models/TvShow.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DiscoverSeriesResponse.g.dart';

@JsonSerializable()
class DiscoverSeriesResponse {
  List<TvShow> series;
  int page;
  @JsonKey(name: 'total_pages')
  int totalPages;
  @JsonKey(name: 'total_results')
  int totalResults;

  DiscoverSeriesResponse({
    required this.series,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });

  factory DiscoverSeriesResponse.fromJson(Map<String, dynamic> json) =>
      _$DiscoverSeriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoverSeriesResponseToJson(this);
}
