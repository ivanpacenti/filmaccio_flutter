import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'api_key.dart';

part 'TmdbApiClient.g.dart';

@RestApi(baseUrl: "https://api.themoviedb.org/3/")
abstract class TmdbApiClient {
  factory TmdbApiClient(Dio dio, {String baseUrl}) = _TmdbApiClient;

  @GET("/movie/top_rated")
  Future<DiscoverMoviesResponse> getTopRatedMovies(
      @Query('api_key') String apiKey,
      @Query('page') int page,
      @Query('language') String language,
      @Query('region') String region,
      );
}

@JsonSerializable()
class DiscoverMoviesResponse {
  List<Movie> results;

  DiscoverMoviesResponse({required this.results});

  factory DiscoverMoviesResponse.fromJson(Map<String, dynamic> json) =>
      _$DiscoverMoviesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DiscoverMoviesResponseToJson(this);
}

@JsonSerializable()
class Movie {
  String title;
  @JsonKey(name: 'poster_path')
  String? posterPath;

  Movie({required this.title, this.posterPath});

  factory Movie.fromJson(Map<String, dynamic> json) =>
      _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
