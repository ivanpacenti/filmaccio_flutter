import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'Firebase/FirestoreService.dart';
import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';
import 'login/Auth.dart';
import 'models/Movie.dart';
import 'models/TvShow.dart';

class OtherUserProfile extends StatefulWidget {
  final String userId;

  OtherUserProfile(this.userId);

  @override
  _OtherUserProfileState createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {

  final User? currentUser = Auth().currentUser;
  final String currentUserId = Auth().currentUser!.uid;

  Map<String, dynamic>? userData; // Dati dell'utente che sto cercando li prendo dalla fu
  // funzione sotto loadUserData() e li salvo in questa variabile di tipo Map una specie di oggetto

  @override
  void initState() {
    super.initState();
    loadUserData();
  }
  Future<void> loadUserData() async {
    userData = await FirestoreService.getUserByUid(widget.userId);
    setState(() {});
  }

  bool isRefreshing = false;

  Future<void> refreshPage() async {
    setState(() {
      isRefreshing = true;
    });
    await Future.delayed(Duration(seconds: 2)); // Simulazione di un'operazione asincrona di ricaricamento
    setState(() {
      isRefreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int? movieMinutes = userData?['movieMinutes'];
    final int? moviesNumber = userData?['moviesNumber'];
    final int? tvMinutes = userData?['tvMinutes'];
    final int? tvNumber  = userData?['tvNumber'];
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: isRefreshing ? null : refreshPage,
            icon: isRefreshing ? CircularProgressIndicator() : Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: FirestoreService.getUserByUid(widget.userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Errore: ${snapshot.error}');
          } else {
            var user = snapshot.data;
            return FutureBuilder(
              future: FirestoreService.getFollowers(widget.userId),
              builder: (BuildContext context, AsyncSnapshot followingSnapshot) {
                if (followingSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (followingSnapshot.hasError) {
                  return Text('Errore: ${followingSnapshot.error}');
                } else {
                  List<String> following = followingSnapshot.data;
                  print('Follower: $following');
                  return SingleChildScrollView(
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
                                  user["backdropImage"],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: (MediaQuery.of(context).size.width / 16 * 9) - 100, // Sposta il cerchio in basso alla metà della sua altezza
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: NetworkImage(user['profileImage']),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 60),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  user['nameShown'],
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  user['username'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    if (userData != null && userData!['uid'].toString() == currentUserId) {
                                      // L'utente sta cercando di seguire se stesso
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Attenzione'),
                                            content: Text('Non puoi seguire te stesso.'),
                                            actions: [
                                              TextButton(
                                                child: Text('OK'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      // L'utente può eseguire l'azione di follow/unfollow
                                      if (following.contains(currentUserId)) {
                                        FirestoreService.unfollowUser(currentUserId, widget.userId);
                                      } else {
                                        FirestoreService.followUser(currentUserId, widget.userId);
                                      }
                                    }
                                  },
                                  child: Text(following.contains(currentUserId) ? 'NON SEGUIRE' : 'SEGUI'),
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
                       // iNIZIA IL CONTAINER CHE CONTIENE IL TEMPO DELLE SERIE TV
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
                                                moviesNumber.toString(),
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
                                              tvNumber.toString(),
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
                                                future: getTotalFollowers(widget.userId),
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
                                                future: getTotalFollowing(widget.userId),
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
                                Text(
                                  'Liste',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
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
                                                  future: getPosters(userData?['uid'], "favorite_m"),
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
                                                  future: getPosters(userData?['uid'], "watched_m"),
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
                                                  future: getPosters(userData?['uid'], "watchlist_m"),
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
                                                'Serie Tv Favorite',
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
                                                  future: getPostersTv(userData?['uid'], "favorite_t"),
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
                                                'Serie Tv in visione',
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
                                                  future: getPostersTv(userData?['uid'], "watching_t"),
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
                                                'Serie Tv da vedere',
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
                                                  future: getPostersTv(userData?['uid'], "watchlist_t"),
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
                                      // se si vuole aggiungere altre card qua
                                    ],
                                  ),
                                ),
                                // RecyclerView per le liste
                                // ...
                                SizedBox(height: 8),
                                Divider(),
                                SizedBox(height: 8),
                                Text('Serie TV viste'),
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
                                              SizedBox(height: 8),
                                              SizedBox(
                                                width: MediaQuery.of(context).size.width - (16 * 2),
                                                height: MediaQuery.of(context).size.height,
                                                child: FutureBuilder<List<TvShow>>(
                                                  future: getPostersTvF(userData?['uid'], "finished_t"),
                                                  builder: (BuildContext context, AsyncSnapshot<List<TvShow>> snapshot) {
                                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                                      return CircularProgressIndicator();
                                                    } else if (snapshot.hasError) {
                                                      return Text('Errore: ${snapshot.error}');
                                                    } else {
                                                      final tvShows = snapshot.data ?? [];
                                                      if (tvShows.isEmpty) { // Se l'elenco delle serie TV è vuoto
                                                        return Center( // Centra il testo nel widget
                                                          child: Text(
                                                            'Ancora nessun film aggiunto', // Il tuo messaggio
                                                            style: TextStyle(fontSize: 16),
                                                          ),
                                                        );
                                                      } else {
                                                        return ListView.builder(
                                                          scrollDirection: Axis.vertical,
                                                          itemCount: tvShows.length,
                                                          itemBuilder: (BuildContext context, int index) {
                                                            final tvShow = tvShows[index];
                                                            return Padding(
                                                              padding: EdgeInsets.only(bottom: 8),
                                                              child: Row(
                                                                children: [
                                                                  ClipOval(
                                                                    child: SizedBox(
                                                                      width: 55,
                                                                      height: 55,
                                                                      child: Image.network(
                                                                        tvShow.posterPath ?? '',
                                                                        fit: BoxFit.cover,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(width: 8), // Spazio tra l'immagine e il titolo
                                                                  Expanded( // Per evitare overflow di testo
                                                                    child: Text(
                                                                      tvShow.name ?? '', // Titolo della serie TV
                                                                      style: TextStyle(fontSize: 16),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        );
                                                      }
                                                    }
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
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
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
  Future<List<String>> getPosters(String uid, String listName) async {
    List<dynamic> list = await FirestoreService.getList(uid, listName);
    if (list.isEmpty) {
      print("La lista è vuota");
      return [];  // ritorna una lista vuota
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
    // PER LE SERIE TV NON CI SBAGLIAMO
    List<dynamic> list = await FirestoreService.getList(uid, listName);
    if (list.isEmpty) {
      print("La lista è vuota");
      return [];  // ritorna una lista vuota
    } else {
      print("La lista non è vuota");
    }
    List<String> posterPathsTv = [];
    String baseUrl = "https://image.tmdb.org/t/p/w185/";

    TmdbApiClient tmdbApiClient = TmdbApiClient(Dio());

    int maxIndex = (list.length <= 3) ? list.length : 3;
    for (int i = 0; i < maxIndex; i++) {
      String serieId = list[i].toString();
      TvShow TvDetails = await tmdbApiClient.getTvDetails(
        apiKey: tmdbApiKey,
        serieId: serieId,
        language: 'it-IT',
        region: 'IT',
      );
      if (TvDetails.posterPath != null) {
        String fullPosterPath = "$baseUrl${TvDetails.posterPath}";
        posterPathsTv.add(fullPosterPath);
      }
    }

    return posterPathsTv;
  }
  Future<List<TvShow>> getPostersTvF(String uid, String listName) async {
    // PER LE SERIE TV FINITE
    List<dynamic> list = await FirestoreService.getList(uid, listName);
    if (list.isEmpty) {
      print("La lista è vuota");
      return [];  // ritorna una lista vuota
    } else {
      print("La lista non è vuota");
    }
    List<TvShow> tvShows = [];
    String baseUrl = "https://image.tmdb.org/t/p/w185/";

    TmdbApiClient tmdbApiClient = TmdbApiClient(Dio());

    int maxIndex = list.length;
    for (int i = 0; i < maxIndex; i++) {
      String seriesId = list[i].toString();
      TvShow tvDetails = await tmdbApiClient.getTvDetails(
        apiKey: tmdbApiKey,
        serieId: seriesId,
        language: 'it-IT',
        region: 'IT',
      );
      if (tvDetails.posterPath != null) {
        String fullPosterPath = "$baseUrl${tvDetails.posterPath}";
        TvShow tvShow = TvShow(
          id: tvDetails.id, // Devi ottenere questo valore da qualche parte
          name: tvDetails.name,
          posterPath: fullPosterPath,
          overview: tvDetails.overview, // Devi ottenere questo valore da qualche parte
          releaseDate: tvDetails.releaseDate, // Devi ottenere questo valore da qualche parte
          backdropPath: tvDetails.backdropPath, // Devi ottenere questo valore da qualche parte
        );
        tvShows.add(tvShow);
      }
    }
    return tvShows;
  }





}

Future<int> getTotalFollowers(String uid) async {
  List<dynamic> peopleFollowed = await FirestoreService.getFollowers(uid);
  int totalFollowers = peopleFollowed.length;
  print('Numero totale dei follower: $totalFollowers');
  return totalFollowers;
}

Future<int> getTotalFollowing(String uid) async {
  List<dynamic> peopleFollowing = await FirestoreService.getFollowing(uid);
  int totalFollowing = peopleFollowing.length;
  print('Numero totale dei follower: $totalFollowing');
  return totalFollowing;
}

Tuple3<String, String, String> convertMinutesToMonthsDaysHours(int minutes) {
  // Questo metodo converte i minuti in mesi, giorni e ore
  var months = (minutes ~/ 43200).toString();
  var days = ((minutes % 43200) ~/ 1440).toString();
  var hours = ((minutes % 1440) ~/ 60).toString();
  if (months.length == 1) months = '0$months';
  if (days.length == 1) days = '0$days';
  if (hours.length == 1) hours = '0$hours';
  return Tuple3(months,days,hours);
}

