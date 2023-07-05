import 'package:json_annotation/json_annotation.dart';
part 'TvShow.g.dart';
@JsonSerializable()
class TvShow {
  String name;
  @JsonKey(name: 'poster_path')
  String? posterPath;

  TvShow({required this.name, this.posterPath});

  factory TvShow.fromJson(Map<String, dynamic> json) =>
      _$TvShowFromJson(json);

  Map<String, dynamic> toJson() => _$TvShowToJson(this);
}