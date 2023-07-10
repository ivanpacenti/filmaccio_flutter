import 'package:filmaccio_flutter/widgets/models/TmdbEntity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'SearchResponse.g.dart';

@JsonSerializable()
class SearchResponse {
  @JsonKey(name: 'results')
  List<TmdbEntity> entities;
  int page;
  @JsonKey(name: 'total_pages')
  int totalPages;
  @JsonKey(name: 'total_results')
  int totalResults;

  SearchResponse({
    required this.entities,
    required this.page,
    required this.totalPages,
    required this.totalResults,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResponseToJson(this);

// List<TmdbEntity> get results => entities;
}
