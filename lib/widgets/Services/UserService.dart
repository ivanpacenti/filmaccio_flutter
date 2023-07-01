import 'package:firebase_auth/firebase_auth.dart';
import '../models/UserModel.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String nameShown = 'Nome Utente Sconosciuto';

  // Metodo per ottenere lo stream dell'utente
  Stream<UserModel> get user {
    return _auth.authStateChanges().map((user) {
      if (user != null) {
        // Restituisci un UserModel con i dati dell'utente corrente
        return UserModel(
          uid: user.uid,
          nameShown:user.displayName??'Nome Utente Sconosciuto',
          email: user.email ?? 'Email Sconosciuta',
        );
      } else {
        // Restituisci un UserModel di default se l'utente non è autenticato
        return UserModel(
          uid: 'uid Sconosciuto',
          nameShown: 'boh',
          email: 'Email Sconosciuta',
        );
      }
    });
  }

  // Metodo per impostare il campo nameShown
  void setNameShown(String nameShown) {
    nameShown = nameShown;
  }
}
