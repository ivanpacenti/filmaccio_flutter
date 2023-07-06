import 'dart:ffi';

import 'package:filmaccio_flutter/widgets/Firebase/FirestoreService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                                                  '2',
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
                                                  '15',
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
                                                  '10',
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
                                  child: Container(
                                    width: 150,
                                    height: 120,
                                    child: Container(),
                                  ),
                                ),
                                // Add other cards here...
                              ],
                            ),
                          ),
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

