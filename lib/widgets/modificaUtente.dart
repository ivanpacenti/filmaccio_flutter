import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      userDocFuture = FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Mostra un AlertDialog di avviso all'apertura della pagina
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Info'),
            content: const Text(
                'Le funzionalità di cambio immagine di profilo e cambio immagine di sfondo non sono state implementate a causa del tempo limitato a disposizione.\n\nSono comunque presenti i componenti necessari per implementarle in futuro.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    });

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
          final String? profileImage = userDoc?.get('profileImage');
          final String? backdropImage = userDoc?.get('backdropImage');
          _nameController.text = nameShown ?? '';
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: const Text('Modifica profilo'),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cambia il tuo nome visualizzato:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(children: [
                    SizedBox(
                      width: 250,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            hintText: 'Nome visualizzato',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.contact_page_rounded),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _nameController.text = "";
                              },
                            )),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final User? currentUser = Auth().currentUser;
                          if (currentUser != null) {
                            FirestoreService.updateUserField(
                                currentUser.uid,
                                'nameShown',
                                _nameController.text, (bool success) {
                              if (success) {
                                Navigator.of(context).pop(
                                    true); // ritorna alla pagina di profilo con un valore true
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Errore durante il cambio nome visualizzato'),
                                  ),
                                );
                              }
                            });
                          }
                        },
                        child: const Text('Conferma'),
                      ),
                    )
                  ]),
                  const Divider(height: 16),
                  Text(
                    'Cambia la tua foto profilo o la tua immagine di sfondo:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(profileImage ?? ''),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Conferma'),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            AspectRatio(
                              aspectRatio: 16 / 9,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  backdropImage ?? '',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Conferma'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Text(
                    'Cambia altre informazioni:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () async {
                      final User? currentUser = Auth().currentUser;
                      if (currentUser != null) {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: currentUser.email!);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Cambio password'),
                                content: const Text(
                                    'Ti è stata inviata una email per il cambio password. Controlla la tua casella di posta e segui le istruzioni.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
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
                                title: const Text('Errore'),
                                content: const Text(
                                    'Si è verificato un errore durante l\'invio della email per il cambio password. Riprova più tardi.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                    child: const Text('Cambio password'),
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
