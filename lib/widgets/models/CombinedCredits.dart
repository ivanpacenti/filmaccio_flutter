import 'package:filmaccio_flutter/widgets/models/Product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CombinedCredits.g.dart';

@JsonSerializable()
class CombinedCredits {
  List<Product> cast;
  List<Product> crew;

  CombinedCredits({
    required this.cast,
    required this.crew,
  });

  factory CombinedCredits.fromJson(Map<String, dynamic> json) =>
      _$CombinedCreditsFromJson(json);

  Map<String, dynamic> toJson() => _$CombinedCreditsToJson(this);
}
