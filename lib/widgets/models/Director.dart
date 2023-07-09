import 'package:json_annotation/json_annotation.dart';

part 'Director.g.dart';

@JsonSerializable()
class Director {
  int id;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'profile_path')
  String? profilePath;
  String? job;

  Director({
    required this.id,
    required this.name,
    this.profilePath,
    required this.job,
  });

  factory Director.fromJson(Map<String, dynamic> json) =>
      _$DirectorFromJson(json);

  Map<String, dynamic> toJson() => _$DirectorToJson(this);
}
