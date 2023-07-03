import 'package:flutter/material.dart';
import 'dart:io';

import '../models/UserData.dart';
class UserProvider extends ChangeNotifier {
  UserData? _userData;

  UserData? get userData => _userData;

  void setUserData(UserData userData) {
    _userData = userData;
    notifyListeners();
  }
}
