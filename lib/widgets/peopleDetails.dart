import 'package:flutter/material.dart';


import 'models/Person.dart';

class PersonDetailsActivity extends StatefulWidget {
  final Person person;

  PersonDetailsActivity({required this.person});

  @override
  _PersonDetailsActivityState createState() => _PersonDetailsActivityState();
}

class _PersonDetailsActivityState extends State<PersonDetailsActivity> {
  bool isFollowed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // I tuoi widget qui
          // Ad esempio, per visualizzare il nome della persona:
          Text(widget.person.name),
          // Per visualizzare l'immagine della persona:
          Image.network('https://image.tmdb.org/t/p/w342${widget.person.profilePath}'),
          // E così via...
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isFollowed = !isFollowed;
          });
        },
        child: Icon(isFollowed ? Icons.check : Icons.add),
      ),
    );
  }
}
