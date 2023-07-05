import 'package:json_annotation/json_annotation.dart';
part 'Product.g.dart';
@JsonSerializable()
class Product {
  int id;
  String title;
  @JsonKey(name: 'poster_path')
  String? posterPath;
  String mediaType;
  double popularity;

  Product({
    required this.id,
    required this.title,
    this.posterPath,
    required this.mediaType,
    required this.popularity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}