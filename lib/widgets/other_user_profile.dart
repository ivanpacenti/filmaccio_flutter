import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Firebase/FirestoreService.dart';
import 'login/Auth.dart';

class OtherUserProfile extends StatelessWidget {
  final String userId;
  final User? currentUser = Auth().currentUser;
  final String currentUserId = Auth().currentUser!.uid;

  OtherUserProfile(this.userId);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirestoreService.getUserByUid(userId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Errore: ${snapshot.error}');
        } else {
          var user = snapshot.data;
          return FutureBuilder(
            future: FirestoreService.getFollowers(userId),
            builder: (BuildContext context, AsyncSnapshot followingSnapshot) {
              if (followingSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (followingSnapshot.hasError) {
                return Text('Errore: ${followingSnapshot.error}');
              } else {
                List<String> following = followingSnapshot.data;
                print('Follower: $following');
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
                                      FirestoreService.unfollowUser(currentUserId, userId);
                                    } else {
                                      FirestoreService.followUser(currentUserId, userId);
                                    }
                                  },
                                  child: Text(following.contains(currentUserId) ? 'NON SEGUIRE' : 'SEGUI'),
                                ),
                                SizedBox(height: 8),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Card(
                                        child: SizedBox(
                                          width: 150,
                                          height: 90,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('TEMPO FILM'),
                                              SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        '12',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                      Text('months'),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        '30',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                      Text('days'),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text(
                                                        '5',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                      Text('hours'),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Altri card simili
                                      // ...
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
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
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
