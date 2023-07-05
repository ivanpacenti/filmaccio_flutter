import 'package:filmaccio_flutter/widgets/models/Character.dart';
import 'package:filmaccio_flutter/widgets/models/Director.dart';
import 'package:json_annotation/json_annotation.dart';
part 'Credits.g.dart';

@JsonSerializable()
class Credits {
  List<Character> cast;
  List<Director> crew;

  Credits({
    required this.cast,
    required this.crew,
  });

  factory Credits.fromJson(Map<String, dynamic> json) => _$CreditsFromJson(json);

  Map<String, dynamic> toJson() => _$CreditsToJson(this);
}