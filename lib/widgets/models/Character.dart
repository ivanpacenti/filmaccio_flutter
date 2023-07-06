import 'package:json_annotation/json_annotation.dart';
part 'Character.g.dart';
@JsonSerializable()
class Character {
  int id;
  @JsonKey(name: 'name')
  String name;
  @JsonKey(name: 'profile_path')
  String? profilePath;
  String character;

  Character({
    required this.id,
    required this.name,
    this.profilePath,
    required this.character,
  });

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}
