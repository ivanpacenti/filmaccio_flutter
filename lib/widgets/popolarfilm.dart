// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'data/api/TmdbApiClient.dart';
// import 'data/api/api_key.dart';
//
//
// class HomeApi extends StatefulWidget {
//   @override
//   _HomeApiState createState() => _HomeApiState();
// }
//
// class _HomeApiState extends State<HomeApi> {
//   final Dio _dio = Dio();
//   late TmdbApiClient _apiClient;
//   List<Movie>? _topMovies;
//
//   void initState() {
//     super.initState();
//     _apiClient = TmdbApiClient(_dio);
//     fetchTopMovies();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 60),
//               child: Container(
//                 margin: EdgeInsets.all(16),
//                 child: Text(
//                   'Film consigliati',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.blue,
//                   ),
//                 ),
//               ),
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: _topMovies?.map((movie) {
//                   return Padding(
//                     padding: EdgeInsets.only(right: 16.0),
//                     child: SizedBox(
//                       width: 110,
//                       height: 165,
//                       child: Card(
//                         clipBehavior: Clip.antiAlias,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Image.network(
//                           'https://image.tmdb.org/t/p/w185/${movie.posterPath}',
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                   );
//                 }).toList() ??
//                     [],
//               ),
//             ),
//
//             SizedBox(height: 16),
//             Container(
//               margin: EdgeInsets.all(1),
//               child: Text(
//                 'Serie consigliate',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   SizedBox(width: 16),
//                   Container(
//                     width: 110,
//                     height: 165,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Container(
//                     width: 110,
//                     height: 165,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Container(
//                     width: 110,
//                     height: 165,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             Container(
//               margin: EdgeInsets.all(16),
//               child: Text(
//                 'Film in tendenza',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   SizedBox(width: 16),
//                   Container(
//                     width: 110,
//                     height: 165,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Container(
//                     width: 110,
//                     height: 165,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Container(
//                     width: 110,
//                     height: 165,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//             Container(
//               margin: EdgeInsets.all(16),
//               child: Text(
//                 'Serie in tendenza',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.blue,
//                 ),
//               ),
//             ),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   SizedBox(width: 16),
//                   Container(
//                     width: 110,
//                     height: 165,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Container(
//                     width: 110,
//                     height: 165,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                   Container(
//                     width: 110,
//                     height: 165,
//                     decoration: BoxDecoration(
//                       color: Colors.grey,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   SizedBox(width: 16),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Future<void> fetchTopMovies() async {
//     try {
//       final response = await _apiClient.getTopRated(tmdbApiKey);
//       setState(() {
//         _topMovies = response.results.take(3).toList();
//       });
//     } catch (error) {
//       print('Error fetching top movies: $error');
//     }
//   }
// }