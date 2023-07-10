import 'package:json_annotation/json_annotation.dart';

part 'TmdbEntity.g.dart';

@JsonSerializable()
class TmdbEntity {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'title')
  final String title;
  @JsonKey(name: 'poster_path')
  final String? imagePath;
  @JsonKey(name: 'media_type')
  final String mediaType;

  TmdbEntity({
    required this.id,
    required this.title,
    this.imagePath,
    required this.mediaType,
  });

  factory TmdbEntity.fromJson(Map<String, dynamic> json) {
    final title = json['title'] ?? json['name'];
    final imagePath = json['poster_path'] ?? json['profile_path'];
    return TmdbEntity(
      id: json['id'] as int,
      title: title as String,
      imagePath: imagePath as String?,
      mediaType: json['media_type'] as String,
    );
  }

  Map<String, dynamic> toJson() => _$TmdbEntityToJson(this);
}
