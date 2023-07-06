
import 'package:json_annotation/json_annotation.dart';

import 'Character.dart';
import 'Director.dart';
part 'Credits.g.dart';

@JsonSerializable()
class Credits {
  @JsonKey(name: 'actors')
  List<Character> cast;
  @JsonKey(name: 'directors')
  List<Director> crew;

  Credits({
    required this.cast,
    required this.crew,
  });

  factory Credits.fromJson(Map<String, dynamic> json) => _$CreditsFromJson(json);

  Map<String, dynamic> toJson() => _$CreditsToJson(this);
}