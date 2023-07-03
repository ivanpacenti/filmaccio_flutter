import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Services/UserService.dart';
import '../models/UserModel.dart';
import 'modificaUtente.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../login/Auth.dart';

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
      userDocFuture = FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: userDocFuture,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot)
    {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Text('Errore: ${snapshot.error}');
      } else {
        final DocumentSnapshot? userDoc = snapshot.data;
        final String? nameShown = userDoc?.get('nameShown');
        final String? email = userDoc?.get('email');
        final String? username = userDoc?.get('username');
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nameShown ?? 'Unknown User',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              username ?? 'username sconosciuto',
                              style: TextStyle(fontSize: 14),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    // Aggiungi qui la logica per la modifica del profilo
                                  final result = await  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ModificaUtente(),
                                      ),
                                    );
                                    if (result == true){
                                            final User? currentUser = Auth().currentUser;
                                            if (currentUser != null) {
                                              userDocFuture = FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
                                              setState(() {});
                                            } // Forza il FutureBuilder a ricostruire con il nuovo Future
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
                                  Card(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
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
                                  // Add other cards here...
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
              ],
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