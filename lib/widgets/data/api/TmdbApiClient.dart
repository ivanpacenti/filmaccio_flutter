import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'api_key.dart';
part 'TmdbApiClient.g.dart';

@RestApi(baseUrl: "https://api.themoviedb.org/3/")
abstract class TmdbApiClient {
  factory TmdbApiClient(Dio dio, {String baseUrl}) = _TmdbApiClient;

  @GET("/movie/popular")
  Future<MovieResponse> getPopularMovies(@Query("api_key") String apiKey);
}


@JsonSerializable()
class MovieResponse {
  List<Movie> results;

  MovieResponse({required this.results});

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}

@JsonSerializable()
class Movie {
  String title;

  Movie({required this.title});

  factory Movie.fromJson(Map<String, dynamic> json) =>
      _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}



//Path: lib\widgets\data\api\TmdbApiClient.dart; lib\widgets\data\api\TmdbApiClient.g.dart