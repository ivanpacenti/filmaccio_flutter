import 'package:flutter/material.dart';

class Profilo extends StatefulWidget {
  const Profilo({super.key});

  @override
  State<Profilo> createState() => _ProfiloState();
}

class _ProfiloState extends State<Profilo> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child:
      IconButton(onPressed: (){}, icon: Icon(Icons.person)),

    );
  }
}
