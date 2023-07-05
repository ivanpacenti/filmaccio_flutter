import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/widgets/models/DiscoverMoviesResponse.dart';
import 'package:filmaccio_flutter/widgets/models/DiscoverTvShowsResponse.dart';
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


  @GET("trending/movie/week")
  Future<DiscoverMoviesResponse> getTrandingMovie(
      @Query('api_key') String apiKey,
      @Query('language') String language,
      );


  @GET("/tv/top_rated")
  Future<DiscoverTvShowsResponse> getTopRatedTv(
      @Query('api_key') String apiKey,
      @Query('page') int page,
      @Query('language') String language,
      @Query('region') String region,
      );

  @GET("trending/tv/week")
  Future<DiscoverTvShowsResponse> getTrandingTV(
      @Query('api_key') String apiKey,
      @Query('language') String language,
      );


  @GET("movie/now_playing")
  Future<DiscoverMoviesResponse> getMovieNowPlaying(
    @Query('api_key') String apiKey,
    @Query('page') int page,
    @Query('language') String language,
    @Query('region') String region,
      );
}

