import 'package:filmaccio_flutter/widgets/nav/bottomnavbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'color_schemes.g.dart';
import 'widgets/login/login.dart';

/// questa classe è la radice della nostra applicazione
///{@autor ivanpacenti}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return MaterialApp(
        title: 'Filmaccio',
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: firebaseAuth.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BottomNavBar();
            } else {
              return LoginPage();
            }
          },
        ),
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme));
  }
}
