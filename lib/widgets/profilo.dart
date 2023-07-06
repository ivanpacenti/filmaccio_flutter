import 'dart:ffi';
import 'package:dio/dio.dart';
import 'package:tuple/tuple.dart';
import 'package:filmaccio_flutter/widgets/Firebase/FirestoreService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';
import 'models/Movie.dart';
import 'modificaUtente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login/Auth.dart';

class Profilo extends StatefulWidget {
  Profilo({Key? key}) : super(key: key);

  @override
  _ProfiloState createState() => _ProfiloState();
}

class _ProfiloState extends State<Profilo> {
  Future<DocumentSnapshot>? userDocFuture;

  @override
  void initState() {
    super.initState();
    final User? currentUser = Auth().currentUser;
    if (currentUser != null) {
      userDocFuture = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: userDocFuture,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Errore: ${snapshot.error}');
        } else {
          final DocumentSnapshot? userDoc = snapshot.data;
          final String? nameShown = userDoc?.get('nameShown');
          final String? uid = userDoc?.get('uid');
          final String? username = userDoc?.get('username');
          final String? profileImage = userDoc?.get('profileImage');
          final String? backdropImage = userDoc?.get('backdropImage');
          final int? moviesNumber = userDoc?.get('moviesNumber');
          final int? movieMinutes = userDoc?.get('movieMinutes');
          final int? tvMinutes = userDoc?.get('tvMinutes');
          return Scaffold(
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Image.network(
                            backdropImage ?? 'https://via.placeholder.com/150',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: (MediaQuery.of(context).size.width / 16 * 9) - 80,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(profileImage ?? 'https://via.placeholder.com/150'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            nameShown ?? 'Unknown User',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            username ?? 'username sconosciuto',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ModificaUtente(),
                                    ),
                                  );
                                  if (result == true) {
                                    final User? currentUser = Auth().currentUser;
                                    if (currentUser != null) {
                                      userDocFuture = FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(currentUser.uid)
                                          .get();
                                      setState(() {});
                                    }
                                  }
                                },
                                child: Text('Modifica'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: logoutFunction,
                                child: Text('Logout'),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Container(
                                  height: 80,
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('TEMPO FILM'),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  convertMinutesToMonthsDaysHours(movieMinutes ?? 0).item1.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text('mesi'),
                                              ],
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              children: [
                                                Text(
                                                  convertMinutesToMonthsDaysHours(movieMinutes ?? 0).item2.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text('giorni'),
                                              ],
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              children: [
                                                Text(
                                                  convertMinutesToMonthsDaysHours(movieMinutes ?? 0).item3.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text('ore'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('TEMPO TV'),
                                        Row(
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  convertMinutesToMonthsDaysHours(tvMinutes ?? 0).item1.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text('mesi'),
                                              ],
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              children: [
                                                Text(
                                                  convertMinutesToMonthsDaysHours(tvMinutes ?? 0).item2.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text('giorni'),
                                              ],
                                            ),
                                            SizedBox(width: 8),
                                            Column(
                                              children: [
                                                Text(
                                                  convertMinutesToMonthsDaysHours(tvMinutes ?? 0).item3.toString(),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text('ore'),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('NUMERO FILM VISTI'),
                                        Text(
                                          moviesNumber.toString() ?? '0' ,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('NUMERO EPISODI VISTI'),
                                        Text(
                                          moviesNumber.toString() ?? '0' ,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('NUMERO FOLLOWER'),
                                        FutureBuilder<int>(
                                          future: getTotalFollowers(uid ?? ''),
                                          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text('Errore: ${snapshot.error}');
                                            } else if (snapshot.hasData) {
                                              int followerCount = snapshot.data ?? 0;
                                              return Text(
                                                followerCount.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              return Text('Nessun dato disponibile');
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 80,
                                  child: Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('NUMERO FOLLOWING'),
                                        FutureBuilder<int>(
                                          future: getTotalFollowing(uid ?? ''),
                                          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text('Errore: ${snapshot.error}');
                                            } else if (snapshot.hasData) {
                                              int followingCount = snapshot.data ?? 0;
                                              return Text(
                                                followingCount.toString(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            } else {
                                              return Text('Nessun dato disponibile');
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                          Text('Liste'),
                          SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Card(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Film Preferiti',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        SizedBox(
                                          width: 130,  // Imposta la larghezza desiderata per il rettangolo
                                          height: 120,  // Altezza fissa
                                          child: FutureBuilder<List<String>>(
                                            future: getPosters(userDoc?.get('uid'), "favorite_m"),
                                            builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text('Errore: ${snapshot.error}');
                                              } else {
                                                final posterPaths = snapshot.data ?? [];
                                                return ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: posterPaths.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(right: 8),
                                                      child: SizedBox(
                                                        width: 40,  // Imposta la larghezza desiderata per il rettangolo
                                                        height: 100,  // Altezza fissa
                                                        child: Image.network(
                                                          posterPaths[index],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Film Finiti',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        SizedBox(
                                          width: 130,  // Imposta la larghezza desiderata per il rettangolo
                                          height: 120,  // Altezza fissa
                                          child: FutureBuilder<List<String>>(
                                            future: getPosters(userDoc?.get('uid'), "watched_m"),
                                            builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text('Errore: ${snapshot.error}');
                                              } else {
                                                final posterPaths = snapshot.data ?? [];
                                                return ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: posterPaths.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(right: 8),
                                                      child: SizedBox(
                                                        width: 40,  // Imposta la larghezza desiderata per il rettangolo
                                                        height: 100,  // Altezza fissa
                                                        child: Image.network(
                                                          posterPaths[index],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Film in watchlist',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        SizedBox(
                                          width: 130,  // Imposta la larghezza desiderata per il rettangolo
                                          height: 120,  // Altezza fissa
                                          child: FutureBuilder<List<String>>(
                                            future: getPosters(userDoc?.get('uid'), "watchlist_m"),
                                            builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                                              if (snapshot.connectionState == ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text('Errore: ${snapshot.error}');
                                              } else {
                                                final posterPaths = snapshot.data ?? [];
                                                return ListView.builder(
                                                  scrollDirection: Axis.horizontal,
                                                  itemCount: posterPaths.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(right: 8),
                                                      child: SizedBox(
                                                        width: 40,  // Imposta la larghezza desiderata per il rettangolo
                                                        height: 100,  // Altezza fissa
                                                        child: Image.network(
                                                          posterPaths[index],
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Aggiungi altre carte qui...
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Divider(),
                          Text('Serie TV viste'),
                          ElevatedButton(
                            onPressed: () {},
                            child: Text('Visualizza tutte'),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Card(
                                  child: Container(
                                    width: 100,
                                    height: 150,
                                    child: Container(),
                                  ),
                                ),
                                // Add other cards here...
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void logoutFunction() async {
    try {
      await Auth().signOut();
      // Aggiungi qui eventuali altre operazioni di pulizia o navigazione dopo il logout
    } catch (e) {
      // Gestisci eventuali errori durante il logout
      print('Errore durante il logout: $e');
    }
  }
  Future<List<String>> getPosters(String uid, String listName) async {
    List<dynamic> list = await FirestoreService.getList(uid, listName);
    if (list.isEmpty) {
      print("La lista è vuota");
      print(list[0].toString());
    } else {
      print("La lista non è vuota");
    }
    List<String> posterPaths = [];
    String baseUrl = "https://image.tmdb.org/t/p/w185/";

    TmdbApiClient tmdbApiClient = TmdbApiClient(Dio());

    int maxIndex = (list.length <= 3) ? list.length : 3;
    for (int i = 0; i < maxIndex; i++) {
      String movieId = list[i].toString();
      Movie movieDetails = await tmdbApiClient.getMovieDetails(
        apiKey: tmdbApiKey,
        movieId: movieId,
        language: 'it-IT',
        region: 'IT',
      );
      if (movieDetails.posterPath != null) {
        String fullPosterPath = "$baseUrl${movieDetails.posterPath}";
        posterPaths.add(fullPosterPath);
      }
    }

    return posterPaths;
  }
  Future<List<String>> getPostersTv(String uid, String listName) async {
    List<dynamic> list = await FirestoreService.getList(uid, listName);
    if (list.isEmpty) {
      print("La lista è vuota");
      print(list[0].toString());
    } else {
      print("La lista non è vuota");
    }
    List<String> posterPathsTv = [];
    String baseUrl = "https://image.tmdb.org/t/p/w185/";

    TmdbApiClient tmdbApiClient = TmdbApiClient(Dio());

    int maxIndex = (list.length <= 3) ? list.length : 3;
    for (int i = 0; i < maxIndex; i++) {
      String movieId = list[i].toString();
      Movie movieDetails = await tmdbApiClient.getMovieDetails(
        apiKey: tmdbApiKey,
        movieId: movieId,
        language: 'it-IT',
        region: 'IT',
      );
      if (movieDetails.posterPath != null) {
        String fullPosterPath = "$baseUrl${movieDetails.posterPath}";
        posterPathsTv.add(fullPosterPath);
      }
    }

    return posterPathsTv;
  }
}

Future<int> getTotalFollowers(String uid) async {
  // ritorna il numero totale dei followers
  List<dynamic> peopleFollowed = await FirestoreService.getFollowers(uid);
  int totalFollowers = peopleFollowed.length;
 // print('Numero totale dei follower: $totalFollowers');
  return totalFollowers;
}

Future<int> getTotalFollowing(String uid) async {
  //ritorna il numero totale dei following
  List<dynamic> peopleFollowing = await FirestoreService.getFollowing(uid);
  int totalFollowing = peopleFollowing.length;
  //print('Numero totale dei follower: $totalFollowing');
  return totalFollowing;
}

Future<int> getTotalMovies( String uid, String listName ) async {
  //ritorna il numero totale dei film visti
  List<dynamic> moviesWatched = await FirestoreService.getList(uid,listName);
  int totalMovies = moviesWatched.length;
  print('Numero totale dei film visti: $totalMovies');
  return totalMovies;
}



Tuple3<String, String, String> convertMinutesToMonthsDaysHours(int minutes) {
  // Questo metodo converte i minuti in mesi, giorni e ore
  var months = (minutes ~/ 43200).toString();
  var days = ((minutes % 43200) ~/ 1440).toString();
  var hours = ((minutes % 1440) ~/ 60).toString();
  if (months.length == 1) months = '0$months';
  if (days.length == 1) days = '0$days';
  if (hours.length == 1) hours = '0$hours';
  return Tuple3(months, days, hours);
}
