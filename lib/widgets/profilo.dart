import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:filmaccio_flutter/widgets/Firebase/FirestoreService.dart';
import 'package:filmaccio_flutter/widgets/models/TvShow.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';
import 'login/Auth.dart';
import 'models/Movie.dart';
import 'modificaUtente.dart';

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
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
          final int? tvNumber = userDoc?.get('tvNumber');
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
                            backdropImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: (MediaQuery.of(context).size.width / 16 * 9) -
                              108,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(profileImage!),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  nameShown!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  username!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                )
                              ]),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              OutlinedButton(
                                onPressed: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ModificaUtente(),
                                    ),
                                  );
                                  if (result == true) {
                                    final User? currentUser =
                                        Auth().currentUser;
                                    if (currentUser != null) {
                                      userDocFuture = FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(currentUser.uid)
                                          .get();
                                      setState(() {});
                                    }
                                  }
                                },
                                child: const Text('Modifica'),
                              ),
                              const SizedBox(width: 16),
                              OutlinedButton(
                                onPressed: logoutFunction,
                                child: const Text('Logout'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                // Card del tempo film
                                Card(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: SizedBox(
                                    width: 150,
                                    height: 90,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            'TEMPO FILM',
                                            style: TextStyle(
                                              fontFamily: 'sans-serif-black',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      convertMinutesToMonthsDaysHours(
                                                              movieMinutes!)
                                                          .item1
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'roboto_bold',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    ),
                                                    const Text(
                                                      'mesi',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      convertMinutesToMonthsDaysHours(
                                                              movieMinutes)
                                                          .item2
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'roboto_bold',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    ),
                                                    const Text(
                                                      'giorni',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      convertMinutesToMonthsDaysHours(
                                                              movieMinutes)
                                                          .item3
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'roboto_bold',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    ),
                                                    const Text(
                                                      'ore',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
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
                                // Card del tempo tv
                                Card(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: SizedBox(
                                    width: 150,
                                    height: 90,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            'TEMPO TV',
                                            style: TextStyle(
                                              fontFamily: 'sans-serif-black',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      convertMinutesToMonthsDaysHours(
                                                              tvMinutes!)
                                                          .item1
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'roboto_bold',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    ),
                                                    const Text(
                                                      'mesi',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      convertMinutesToMonthsDaysHours(
                                                              tvMinutes)
                                                          .item2
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'roboto_bold',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    ),
                                                    const Text(
                                                      'giorni',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      convertMinutesToMonthsDaysHours(
                                                              tvMinutes)
                                                          .item3
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'roboto_bold',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                      ),
                                                    ),
                                                    const Text(
                                                      'ore',
                                                      style: TextStyle(
                                                          fontSize: 12),
                                                    ),
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
                                // Card del numero di film visti
                                Card(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: SizedBox(
                                    width: 150,
                                    height: 90,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            'FILM VISTI',
                                            style: TextStyle(
                                              fontFamily: 'sans-serif-black',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            moviesNumber.toString() ?? '0',
                                            style: TextStyle(
                                              fontFamily: 'sans-serif-black',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Card del numero di episodi visti
                                Card(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: SizedBox(
                                    width: 150,
                                    height: 90,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            'EPISODI VISTI',
                                            style: TextStyle(
                                              fontFamily: 'sans-serif-black',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: Text(
                                            tvNumber.toString(),
                                            style: TextStyle(
                                              fontFamily: 'sans-serif-black',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // Card del numero di followers
                                Card(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: SizedBox(
                                    width: 150,
                                    height: 90,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            'FOLLOWERS',
                                            style: TextStyle(
                                              fontFamily: 'sans-serif-black',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: FutureBuilder<int>(
                                            future:
                                                getTotalFollowers(uid ?? ''),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<int> snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Errore: ${snapshot.error}');
                                              } else if (snapshot.hasData) {
                                                int followersCount =
                                                    snapshot.data ?? 0;
                                                return Text(
                                                  followersCount.toString(),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                );
                                              } else {
                                                return const Text(
                                                    'Nessun dato disponibile');
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  margin: const EdgeInsets.only(right: 4),
                                  child: SizedBox(
                                    width: 150,
                                    height: 90,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            'SEGUITI',
                                            style: TextStyle(
                                              fontFamily: 'sans-serif-black',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          child: FutureBuilder<int>(
                                            future:
                                                getTotalFollowing(uid ?? ''),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<int> snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator();
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Errore: ${snapshot.error}');
                                              } else if (snapshot.hasData) {
                                                int followingCount =
                                                    snapshot.data ?? 0;
                                                return Text(
                                                  followingCount.toString(),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                  ),
                                                );
                                              } else {
                                                return const Text(
                                                    'Nessun dato disponibile');
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Text(
                            'Liste',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Card(
                                  child: SizedBox(
                                    width: 150,
                                    height: 110,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            'PREFERITI (FILM)',
                                            style: TextStyle(
                                              fontFamily: 'sans-serif-black',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          // Imposta la larghezza desiderata per il rettangolo
                                          width: 130,
                                          // Altezza fissa
                                          height: 65,
                                          child: FutureBuilder<List<String>>(
                                            future: getPosters(
                                                userDoc?.get('uid'),
                                                "favorite_m"),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<List<String>>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    child:
                                                        const CircularProgressIndicator(),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Errore: ${snapshot.error}');
                                              } else {
                                                final posterPaths =
                                                    snapshot.data ?? [];
                                                return ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: posterPaths.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                        width: 40,
                                                        height: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          color: Colors.grey,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                posterPaths[
                                                                    index]),
                                                            fit: BoxFit.cover,
                                                          ),
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
                                  child: SizedBox(
                                    width: 150,
                                    height: 110,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            'VISTI (FILM)',
                                            style: TextStyle(
                                              fontFamily: 'sans-serif-black',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          // Imposta la larghezza desiderata per il rettangolo
                                          width: 130,
                                          // Altezza fissa
                                          height: 65,
                                          child: FutureBuilder<List<String>>(
                                            future: getPosters(
                                                userDoc?.get('uid'),
                                                "watched_m"),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<List<String>>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Errore: ${snapshot.error}');
                                              } else {
                                                final posterPaths =
                                                    snapshot.data ?? [];
                                                return ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: posterPaths.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                        width: 40,
                                                        height: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          color: Colors.grey,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                posterPaths[
                                                                    index]),
                                                            fit: BoxFit.cover,
                                                          ),
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
                                  child: SizedBox(
                                    width: 150,
                                    height: 110,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            'WATCHLIST (FILM)',
                                            style: TextStyle(
                                              fontFamily: 'sans-serif-black',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          // Imposta la larghezza desiderata per il rettangolo
                                          width: 130,
                                          // Altezza fissa
                                          height: 65,
                                          child: FutureBuilder<List<String>>(
                                            future: getPosters(
                                                userDoc?.get('uid'),
                                                "watchlist_m"),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<List<String>>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Errore: ${snapshot.error}');
                                              } else {
                                                final posterPaths =
                                                    snapshot.data ?? [];
                                                return ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: posterPaths.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                        width: 40,
                                                        height: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          color: Colors.grey,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                posterPaths[
                                                                    index]),
                                                            fit: BoxFit.cover,
                                                          ),
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
                                  child: SizedBox(
                                    width: 150,
                                    height: 110,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            'PREFERITI (TV)',
                                            style: TextStyle(
                                              fontFamily: 'sans-serif-black',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          // Imposta la larghezza desiderata per il rettangolo
                                          width: 130,
                                          // Altezza fissa
                                          height: 65,
                                          child: FutureBuilder<List<String>>(
                                            future: getPostersTv(
                                                userDoc?.get('uid'),
                                                "favorite_t"),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<List<String>>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Errore: ${snapshot.error}');
                                              } else {
                                                final posterPaths =
                                                    snapshot.data ?? [];
                                                return ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: posterPaths.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                        width: 40,
                                                        height: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          color: Colors.grey,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                posterPaths[
                                                                    index]),
                                                            fit: BoxFit.cover,
                                                          ),
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
                                  child: SizedBox(
                                    width: 150,
                                    height: 110,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            'IN VISIONE (TV)',
                                            style: TextStyle(
                                              fontFamily: 'sans-serif-black',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          // Imposta la larghezza desiderata per il rettangolo
                                          width: 130,
                                          // Altezza fissa
                                          height: 65,
                                          child: FutureBuilder<List<String>>(
                                            future: getPostersTv(
                                                userDoc?.get('uid'),
                                                "watching_t"),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<List<String>>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    child:
                                                        const CircularProgressIndicator(),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Errore: ${snapshot.error}');
                                              } else {
                                                final posterPaths =
                                                    snapshot.data ?? [];
                                                return ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: posterPaths.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                        width: 40,
                                                        height: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          color: Colors.grey,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                posterPaths[
                                                                    index]),
                                                            fit: BoxFit.cover,
                                                          ),
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
                                  child: SizedBox(
                                    width: 150,
                                    height: 110,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 4),
                                          child: Text(
                                            'WATCHLIST (TV)',
                                            style: TextStyle(
                                              fontFamily: 'sans-serif-black',
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        SizedBox(
                                          // Imposta la larghezza desiderata per il rettangolo
                                          width: 130,
                                          // Altezza fissa
                                          height: 65,
                                          child: FutureBuilder<List<String>>(
                                            future: getPostersTv(
                                                userDoc?.get('uid'),
                                                "watchlist_t"),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<List<String>>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Center(
                                                  child: Container(
                                                    width: 50,
                                                    height: 50,
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Errore: ${snapshot.error}');
                                              } else {
                                                final posterPaths =
                                                    snapshot.data ?? [];
                                                return ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount: posterPaths.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                        width: 40,
                                                        height: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          color: Colors.grey,
                                                          image:
                                                              DecorationImage(
                                                            image: NetworkImage(
                                                                posterPaths[
                                                                    index]),
                                                            fit: BoxFit.cover,
                                                          ),
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
                          const SizedBox(height: 8),
                          const Divider(),
                          Text(
                            'Serie TV completate',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: FutureBuilder<List<TvShow>>(
                                future: getPostersTvF(
                                    userDoc?.get('uid'), "finished_t"),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<TvShow>> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Center(
                                        child:
                                            Text('Errore: ${snapshot.error}'));
                                  } else {
                                    final tvShows = snapshot.data ?? [];
                                    if (tvShows.isEmpty || tvShows.isEmpty) {
                                      return const Center(
                                        child: Text(
                                          'Ancora nessuna serie TV completata',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      );
                                    } else {
                                      return ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: tvShows.length,
                                        itemBuilder: (context, index) {
                                          final tvShow = tvShows[index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 8),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.network(
                                                    tvShow.posterPath ?? '',
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    tvShow.name ?? " ",
                                                    style: const TextStyle(
                                                        fontSize: 14),
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
      return []; // ritorna una lista vuota
    } else {}
    List<String> posterPaths = [];
    String baseUrl = "https://image.tmdb.org/t/p/w185/";

    TmdbApiClient tmdbApiClient = TmdbApiClient(Dio());

    int maxIndex = list.length;
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
      return []; // ritorna una lista vuota
    } else {}
    List<String> posterPathsTv = [];
    String baseUrl = "https://image.tmdb.org/t/p/w185/";

    TmdbApiClient tmdbApiClient = TmdbApiClient(Dio());

    int maxIndex = list.length;
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
      return []; // ritorna una lista vuota
    } else {}
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
          id: tvDetails.id,
          name: tvDetails.name,
          posterPath: fullPosterPath,
          overview: tvDetails.overview,
          releaseDate: tvDetails.releaseDate,
          backdropPath: tvDetails.backdropPath,
        );

        tvShows.add(tvShow);
      }
    }
    return tvShows;
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

Future<int> getTotalMovies(String uid, String listName) async {
  //ritorna il numero totale dei film visti
  List<dynamic> moviesWatched = await FirestoreService.getList(uid, listName);
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
