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
      appBar: AppBar(
        title: Text(widget.person.name),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.person.profilePath != null)
                Center(
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w342${widget.person.profilePath}',
                  ),
                ),
              SizedBox(height: 16),
              Text(
                'Biography:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 8),
              Text(widget.person.biography),
              SizedBox(height: 16),
              Text(
                'Birthday:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 8),
              Text(widget.person.birthday ?? 'Unknown'),
              SizedBox(height: 16),
              Text(
                'Place of Birth:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 8),
              Text(widget.person.placeOfBirth ?? 'Unknown'),
              // Aggiungi qui altri dettagli sulla persona...
            ],
          ),
        ),
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
