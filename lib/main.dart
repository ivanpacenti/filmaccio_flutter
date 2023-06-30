import 'package:filmaccio_flutter/widgets/nav/bottomnavbar.dart';

import 'package:filmaccio_flutter/widgets/login/auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'widgets/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatefulWidget {

   MyApp({super.key});


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(

        title: 'Filmaccio',
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: Auth().authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BottomNavBar();
            } else {
              return LoginPage();
            }
          },
        )
    );
  }
}