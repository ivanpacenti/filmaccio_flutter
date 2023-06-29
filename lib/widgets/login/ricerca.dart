import 'package:flutter/material.dart';

import 'auth.dart';
class Ricerca extends StatefulWidget {
  const Ricerca({super.key});

  @override
  State<Ricerca> createState() => _RicercaState();
}
Future<void> SignOut( ) async
{
  await Auth().signOut();
}
class _RicercaState extends State<Ricerca> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child:
      IconButton(onPressed: (){}, icon: Icon(Icons.search)),

    );
  }
}
