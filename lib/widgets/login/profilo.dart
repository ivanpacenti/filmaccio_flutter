import 'package:filmaccio_flutter/widgets/login/RegTerza.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Services/UserService.dart';
import '../models/UserModel.dart';
import 'modificaUtente.dart';

import '../login/Auth.dart';
class Profilo extends StatelessWidget {
  const Profilo({Key? key}) : super(key: key);

  get modificaUtente => null;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: UserService().user,
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          final UserModel? currentUser = snapshot.data;
          final String? nameShown = currentUser?.nameShown;
          final String? email = currentUser?.email;

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
                                email ?? 'No Email',
                                style: TextStyle(fontSize: 14),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Aggiungi qui la logica per la modifica del profilo
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ModificaUtente(),
                                      ),
                                    );
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
      await FirebaseAuth.instance.signOut();
      // Aggiungi qui eventuali altre operazioni di pulizia o navigazione dopo il logout
    } catch (e) {
      // Gestisci eventuali errori durante il logout
      print('Errore durante il logout: $e');
    }
  }
  

}
