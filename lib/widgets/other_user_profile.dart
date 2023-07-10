import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'Firebase/FirestoreService.dart';
import 'data/api/TmdbApiClient.dart';
import 'data/api/api_key.dart';
import 'login/Auth.dart';
import 'models/Movie.dart';
import 'models/TvShow.dart';


/// classe per la visualizzazione del profilo  di altri utenti
///{@autor nicolaPiccia}
///{@autor nicolobartolinii}
class OtherUserProfile extends StatefulWidget {
  final String userId;

  OtherUserProfile(this.userId);

  @override
  _OtherUserProfileState createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  final User? currentUser = Auth().currentUser;
  final String currentUserId = Auth().currentUser!.uid;
  bool isFollowed = false;

  Map<String, dynamic>?
      userData; // Dati dell'utente che sto cercando li prendo dalla fu
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

  @override
  Widget build(BuildContext context) {
    final int? movieMinutes = userData?['movieMinutes'];
    final int? moviesNumber = userData?['moviesNumber'];
    final int? tvMinutes = userData?['tvMinutes'];
    final int? tvNumber = userData?['tvNumber'];
    return Scaffold(
      body: FutureBuilder(
        future: FirestoreService.getUserByUid(widget.userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Errore: ${snapshot.error}');
          } else {
            var user = snapshot.data;
            return FutureBuilder(
              future: FirestoreService.getFollowers(widget.userId),
              builder: (BuildContext context, AsyncSnapshot followingSnapshot) {
                if (followingSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
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
                                  user['backdropImage'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: (MediaQuery.of(context).size.width /
                                        16 *
                                        9) -
                                    108,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      NetworkImage(user['profileImage']),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        user['nameShown'],
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        user['username'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      )
                                    ]),
                                const SizedBox(height: 8),
                                FollowButton(
                                    userId: user['uid'],
                                    currentUserId: currentUserId),
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
                                                padding:
                                                    EdgeInsets.only(top: 4),
                                                child: Text(
                                                  'TEMPO FILM',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
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
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
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
                                                            MainAxisAlignment
                                                                .center,
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
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
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
                                                            MainAxisAlignment
                                                                .center,
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
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
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
                                                padding:
                                                    EdgeInsets.only(top: 4),
                                                child: Text(
                                                  'TEMPO TV',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
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
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
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
                                                            MainAxisAlignment
                                                                .center,
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
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
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
                                                            MainAxisAlignment
                                                                .center,
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
                                                                  FontWeight
                                                                      .bold,
                                                              color: Theme.of(
                                                                      context)
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
                                                padding:
                                                    EdgeInsets.only(top: 4),
                                                child: Text(
                                                  'FILM VISTI',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Text(
                                                  moviesNumber.toString(),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
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
                                                padding:
                                                    EdgeInsets.only(top: 4),
                                                child: Text(
                                                  'EPISODI VISTI',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Text(
                                                  tvNumber.toString(),
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
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
                                                padding:
                                                    EdgeInsets.only(top: 4),
                                                child: Text(
                                                  'FOLLOWERS',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: FutureBuilder<int>(
                                                  future: getTotalFollowers(
                                                      user['uid'] ?? ''),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<int>
                                                              snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator();
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Errore: ${snapshot.error}');
                                                    } else if (snapshot
                                                        .hasData) {
                                                      int followersCount =
                                                          snapshot.data ?? 0;
                                                      return Text(
                                                        followersCount
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'sans-serif-black',
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
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
                                                padding:
                                                    EdgeInsets.only(top: 4),
                                                child: Text(
                                                  'SEGUITI',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: FutureBuilder<int>(
                                                  future: getTotalFollowing(
                                                      user['uid'] ?? ''),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<int>
                                                              snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const CircularProgressIndicator();
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Errore: ${snapshot.error}');
                                                    } else if (snapshot
                                                        .hasData) {
                                                      int followingCount =
                                                          snapshot.data ?? 0;
                                                      return Text(
                                                        followingCount
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'sans-serif-black',
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
                                                padding:
                                                    EdgeInsets.only(top: 4),
                                                child: Text(
                                                  'PREFERITI (FILM)',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
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
                                                child:
                                                    FutureBuilder<List<String>>(
                                                  future: getPosters(
                                                      user['uid'],
                                                      "favorite_m"),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  List<String>>
                                                              snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child: SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Errore: ${snapshot.error}');
                                                    } else {
                                                      final posterPaths =
                                                          snapshot.data ?? [];
                                                      return ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            posterPaths.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
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
                                                                color:
                                                                    Colors.grey,
                                                                image:
                                                                    DecorationImage(
                                                                  image: NetworkImage(
                                                                      posterPaths[
                                                                          index]),
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                padding:
                                                    EdgeInsets.only(top: 4),
                                                child: Text(
                                                  'VISTI (FILM)',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
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
                                                child:
                                                    FutureBuilder<List<String>>(
                                                  future: getPosters(
                                                      user['uid'], "watched_m"),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  List<String>>
                                                              snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child: SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Errore: ${snapshot.error}');
                                                    } else {
                                                      final posterPaths =
                                                          snapshot.data ?? [];
                                                      return ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            posterPaths.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
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
                                                                color:
                                                                    Colors.grey,
                                                                image:
                                                                    DecorationImage(
                                                                  image: NetworkImage(
                                                                      posterPaths[
                                                                          index]),
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                padding:
                                                    EdgeInsets.only(top: 4),
                                                child: Text(
                                                  'WATCHLIST (FILM)',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
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
                                                child:
                                                    FutureBuilder<List<String>>(
                                                  future: getPosters(
                                                      user['uid'],
                                                      "watchlist_m"),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  List<String>>
                                                              snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child: SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Errore: ${snapshot.error}');
                                                    } else {
                                                      final posterPaths =
                                                          snapshot.data ?? [];
                                                      return ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            posterPaths.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
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
                                                                color:
                                                                    Colors.grey,
                                                                image:
                                                                    DecorationImage(
                                                                  image: NetworkImage(
                                                                      posterPaths[
                                                                          index]),
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                padding:
                                                    EdgeInsets.only(top: 4),
                                                child: Text(
                                                  'PREFERITI (TV)',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
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
                                                child:
                                                    FutureBuilder<List<String>>(
                                                  future: getPostersTv(
                                                      user['uid'],
                                                      "favorite_t"),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  List<String>>
                                                              snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child: SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Errore: ${snapshot.error}');
                                                    } else {
                                                      final posterPaths =
                                                          snapshot.data ?? [];
                                                      return ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            posterPaths.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
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
                                                                color:
                                                                    Colors.grey,
                                                                image:
                                                                    DecorationImage(
                                                                  image: NetworkImage(
                                                                      posterPaths[
                                                                          index]),
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                padding:
                                                    EdgeInsets.only(top: 4),
                                                child: Text(
                                                  'IN VISIONE (TV)',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
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
                                                child:
                                                    FutureBuilder<List<String>>(
                                                  future: getPostersTv(
                                                      user['uid'],
                                                      "watching_t"),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  List<String>>
                                                              snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child: SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Errore: ${snapshot.error}');
                                                    } else {
                                                      final posterPaths =
                                                          snapshot.data ?? [];
                                                      return ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            posterPaths.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
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
                                                                color:
                                                                    Colors.grey,
                                                                image:
                                                                    DecorationImage(
                                                                  image: NetworkImage(
                                                                      posterPaths[
                                                                          index]),
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                padding:
                                                    EdgeInsets.only(top: 4),
                                                child: Text(
                                                  'WATCHLIST (TV)',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        'sans-serif-black',
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
                                                child:
                                                    FutureBuilder<List<String>>(
                                                  future: getPostersTv(
                                                      user['uid'],
                                                      "watchlist_t"),
                                                  builder:
                                                      (BuildContext context,
                                                          AsyncSnapshot<
                                                                  List<String>>
                                                              snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child: SizedBox(
                                                          width: 50,
                                                          height: 50,
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Text(
                                                          'Errore: ${snapshot.error}');
                                                    } else {
                                                      final posterPaths =
                                                          snapshot.data ?? [];
                                                      return ListView.builder(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemCount:
                                                            posterPaths.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
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
                                                                color:
                                                                    Colors.grey,
                                                                image:
                                                                    DecorationImage(
                                                                  image: NetworkImage(
                                                                      posterPaths[
                                                                          index]),
                                                                  fit: BoxFit
                                                                      .cover,
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: FutureBuilder<List<TvShow>>(
                                      future: getPostersTvF(
                                          user['uid'], "finished_t"),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<TvShow>>
                                              snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: SizedBox(
                                              width: 50,
                                              height: 50,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Errore: ${snapshot.error}'));
                                        } else {
                                          final tvShows = snapshot.data ?? [];
                                          if (tvShows.isEmpty ||
                                              tvShows.isEmpty) {
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8),
                                                  child: Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                        child: Image.network(
                                                          tvShow.posterPath ??
                                                              '',
                                                          width: 50,
                                                          height: 50,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Expanded(
                                                        child: Text(
                                                          tvShow.name ?? " ",
                                                          style:
                                                              const TextStyle(
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
      return []; // ritorna una lista vuota
    }
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
      print("La lista è vuota");
      return []; // ritorna una lista vuota
    } else {
      print("La lista non è vuota");
    }
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
      print("La lista è vuota");
      return []; // ritorna una lista vuota
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
          id: tvDetails.id,
          // Devi ottenere questo valore da qualche parte
          name: tvDetails.name,
          posterPath: fullPosterPath,
          overview: tvDetails.overview,
          // Devi ottenere questo valore da qualche parte
          releaseDate: tvDetails.releaseDate,
          // Devi ottenere questo valore da qualche parte
          backdropPath: tvDetails
              .backdropPath, // Devi ottenere questo valore da qualche parte
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
  return Tuple3(months, days, hours);
}

class FollowButton extends StatefulWidget {
  final String userId;
  final String currentUserId;

  FollowButton({required this.userId, required this.currentUserId});

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool isFollowing = false;

  @override
  void initState() {
    super.initState();
    fetchInitialFollowState();
  }

  Future<void> fetchInitialFollowState() async {
    List<String> following =
        await FirestoreService.getFollowing(widget.currentUserId);
    setState(() {
      isFollowing = following.contains(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: OutlinedButton(
        onPressed: () async {
          if (widget.currentUserId != widget.userId) {
            if (isFollowing) {
              await FirestoreService.unfollowUser(
                  widget.currentUserId, widget.userId);
            } else {
              await FirestoreService.followUser(
                  widget.currentUserId, widget.userId);
            }
            setState(() {
              isFollowing = !isFollowing;
            });
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Attenzione'),
                  content: const Text('Non puoi seguire te stesso.'),
                  actions: [
                    TextButton(
                      child: const Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Text(isFollowing ? 'SEGUI GIÀ' : 'SEGUI'),
      ),
    );
  }
}
