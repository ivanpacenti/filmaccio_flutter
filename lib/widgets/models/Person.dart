import 'package:filmaccio_flutter/widgets/models/CombinedCredits.dart';
import 'package:filmaccio_flutter/widgets/models/Product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'Person.g.dart';

@JsonSerializable()
class Person {
  int id;
  String name;
  @JsonKey(name: 'profile_path')
  String? profilePath;
  String? biography;
  String? birthday;
  String? deathday;
  @JsonKey(name: 'place_of_birth')
  String? placeOfBirth;
  int? gender;
  @JsonKey(name: 'known_for_department')
  String knownFor;
  @JsonKey(name: 'place_of_death')
  String? placeOfDeath;
  final CombinedCredits? combinedCredits;

  List<Product>? products = [];

  Person({
    required this.id,
    required this.name,
    this.profilePath,
    required this.biography,
    this.birthday,
    this.deathday,
    this.placeOfBirth,
    required this.gender,
    required this.knownFor,
    this.placeOfDeath,
    this.combinedCredits,
  });

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
