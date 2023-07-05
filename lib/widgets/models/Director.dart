import 'package:json_annotation/json_annotation.dart';
part 'Director.g.dart';
@JsonSerializable()
class Director {
  int id;
  String name;
  String job;

  Director({
    required this.id,
    required this.name,
    required this.job,
  });

  factory Director.fromJson(Map<String, dynamic> json) => _$DirectorFromJson(json);

  Map<String, dynamic> toJson() => _$DirectorToJson(this);
}