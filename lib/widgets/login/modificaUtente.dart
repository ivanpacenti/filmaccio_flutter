import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Auth.dart';

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
                        updateUserName();
                        Navigator.of(context).pop(true); // ritorna alla pagina di profilo con un valore true
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
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/images/default_propic.png'),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Aggiungi qui la logica per cambiare la foto profilo
                      },
                      child: Text('Cambia foto profilo'),
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
                      onPressed: () {
                        // Aggiungi qui la logica per il cambio password
                      },
                      child: Text('Cambio password'),
                    ),
                  ],
                ),
              ),
            );
          }
        }
    );
  }

  void updateUserName() async {
    final User? currentUser = Auth().currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid)
          .update({'nameShown': _nameController.text});
    }
  }
}
