import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'Firebase/FirestoreService.dart';
import 'login/Auth.dart';

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
                                    if (following.contains(currentUserId)) {
                                      FirestoreService.unfollowUser(currentUserId, widget.userId);
                                    } else {
                                      FirestoreService.followUser(currentUserId, widget.userId);
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
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Liste',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(height: 8),
                                // RecyclerView per le liste
                                // ...
                                SizedBox(height: 8),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Serie TV',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Visto',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Azione del pulsante "Vedi tutto"
                                      },
                                      child: Text('VEDI TUTTO'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                // RecyclerView per le serie TV
                                // ...
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Non c\'è molto da vedere qui',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
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
                  );
                }
              },
            );
          }
        },
      ),
    );
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

