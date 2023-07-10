import 'dart:io';

class UserData {
  late String _nomeUtente;
  late String _email;
  late String _password;
  late String _genere;
  late DateTime _dataNascita;
  late String _nomeVisualizzato;
  late File _avatar;

  String get nomeUtente => _nomeUtente;

  set nomeUtente(String value) {
    _nomeUtente = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get genere => _genere;

  set genere(String value) {
    _genere = value;
  }

  DateTime get dataNascita => _dataNascita;

  set dataNascita(DateTime value) {
    _dataNascita = value;
  }

  String get nomeVisualizzato => _nomeVisualizzato;

  set nomeVisualizzato(String value) {
    _nomeVisualizzato = value;
  }

  File get avatar => _avatar;

  set avatar(File value) {
    _avatar = value;
  }
}
