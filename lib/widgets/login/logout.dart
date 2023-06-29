import 'package:flutter/material.dart';

import 'auth.dart';
class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}
Future<void> SignOut( ) async
{
  await Auth().signOut();
}
class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child:
      IconButton(onPressed: (){SignOut();}, icon: Icon(Icons.logout)),

    );
  }
}
