import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/widgets/models/DiscoverMoviesResponse.dart';
import 'package:filmaccio_flutter/widgets/models/DiscoverTvShowsResponse.dart';
import 'package:filmaccio_flutter/widgets/models/Movie.dart';
import 'package:filmaccio_flutter/widgets/models/SearchResponse.dart';
import 'package:filmaccio_flutter/widgets/models/TvShow.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/Person.dart';

part 'TmdbApiClient.g.dart';

@RestApi(baseUrl: "https://api.themoviedb.org/3/")
abstract class TmdbApiClient {
  factory TmdbApiClient(Dio dio, {String baseUrl}) = _TmdbApiClient;

  @GET("/movie/top_rated")
  // endpoint per trovare li film più votati
  Future<DiscoverMoviesResponse> getTopRatedMovies(
    @Query('api_key') String apiKey,
    @Query('page') int page,
    @Query('language') String language,
    @Query('region') String region,
  );

  @GET("trending/movie/week")
  //endpoint per trovare i film in evidenza sta settimana (trending)
  Future<DiscoverMoviesResponse> getTrandingMovie(
    @Query('api_key') String apiKey,
    @Query('language') String language,
    @Query('region') String region,
  );

  @GET("/tv/top_rated")
  // endpoint per trovare le serie tv più votati
  Future<DiscoverTvShowsResponse> getTopRatedTv(
    @Query('api_key') String apiKey,
    @Query('page') int page,
    @Query('language') String language,
    @Query('region') String region,
  );

  @GET("trending/tv/week")
  // endpoint per trovare le serie tv in evidenza sta settimana (trending)
  Future<DiscoverTvShowsResponse> getTrandingTV(
    @Query('api_key') String apiKey,
    @Query('language') String language,
    @Query('region') String region,
  );

  @GET("movie/now_playing")
  // endpoint per trovare i film in sala
  Future<DiscoverMoviesResponse> getMovieNowPlaying(
    @Query('api_key') String apiKey,
    @Query('page') int page,
    @Query('language') String language,
    @Query('region') String region,
  );

  @GET("movie/{movie_id}")
// endpoint per trovare i dettagli di un film
  Future<Movie> getMovieDetails({
    @Query('api_key') required String apiKey,
    @Path('movie_id') required String movieId,
    @Query('language') required String language,
    @Query('region') required String region,
    @Query('append_to_response') String appendToResponse = 'credits',
  });

  @GET("tv/{series_id}")
// endpoint per trovare i dettagli di un film
  Future<TvShow> getTvDetails({
    @Query('api_key') required String apiKey,
    @Path('series_id') required String serieId,
    @Query('language') required String language,
    @Query('region') required String region,
    @Query('append_to_response') String appendToResponse = '',
  });

  @GET("/search/multi")
  // endpoint per la ricerca
  Future<SearchResponse> searchMulti({
    @Query('api_key') required String apiKey,
    @Query("query") required String query,
    @Query('page') int page = 1,
    @Query('language') String language = 'it-IT',
    @Query("include_adult") bool includeAdult = false,
  });

  @GET("person/{person_id}")
  Future<Person> getPersonDetails({
    @Query("api_key") required String apiKey,
    @Path("person_id") required String personId,
    @Query("language") String language = 'it-IT',
    @Query("region") required String region,
    @Query("append_to_response") String appendToResponse = '',
  });
}
