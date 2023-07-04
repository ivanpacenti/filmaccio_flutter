import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'Firebase/FirestoreService.dart';
import 'login/Auth.dart';

class ModificaUtente extends StatefulWidget {
  ModificaUtente({Key? key}) : super(key: key);

  @override
  _ModificaUtenteState createState() => _ModificaUtenteState();
}

class _ModificaUtenteState extends State<ModificaUtente> {
  final TextEditingController _nameController = TextEditingController();
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
    // Mostra un AlertDialog di avviso all'apertura della pagina
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('AVVISO'),
            content: Text('La funzione per modificare le immagini non è stata implementata, ma è rimasta la predisposizione dei pulsanti sia per un fatto estetico sia per la volontà di completare lo sviluppo in Flutter e renderla simile a quella in Kotlin.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });

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
          final String? profileImage = userDoc?.get('profileImage');
          final String? backdropImage = userDoc?.get('backdropImage');
          _nameController.text = nameShown ?? '';
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text('Edit Profile'),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cambia il tuo nome visualizzato:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Nome visualizzato',
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final User? currentUser = Auth().currentUser;
                      if (currentUser != null) {
                        FirestoreService.updateUserField(currentUser.uid, 'nameShown', _nameController.text, (bool success) {
                          if (success) {
                            Navigator.of(context).pop(true); // ritorna alla pagina di profilo con un valore true
                          } else {
                            // Gestisci il caso in cui l'aggiornamento non sia riuscito
                          }
                        });
                      }
                    },
                    child: Text('Salva'),
                  ),
                  Divider(height: 16),
                  Text(
                    'Cambia la tua foto profilo o la tua immagine di sfondo:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(profileImage ?? ''),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Aggiungi qui la logica per cambiare la foto profilo
                            },
                            child: Text('Cambia foto profilo'),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            width: 150,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.network(
                              backdropImage ?? 'https://via.placeholder.com/150',
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              // Aggiungi qui la logica per cambiare l'immagine di copertina
                            },
                            child: Text('Cambia immagine di copertina'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(height: 16),
                  Text(
                    'Cambia altre informazioni:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      final User? currentUser = Auth().currentUser;
                      if (currentUser != null) {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: currentUser.email!);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Cambio password'),
                                content: Text('Ti è stata inviata una email per il cambio password. Controlla la tua casella di posta e segui le istruzioni.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Errore'),
                                content: Text('Si è verificato un errore durante l\'invio della email per il cambio password. Riprova più tardi.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    child: Text('Cambio password'),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
