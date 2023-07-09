import 'package:filmaccio_flutter/widgets/Firebase/FirestoreService.dart';
import 'package:filmaccio_flutter/widgets/MovieDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login/Auth.dart';
import 'models/Person.dart';

class PersonDetailsActivity extends StatefulWidget {
  final Person person;

  PersonDetailsActivity({required this.person});

  @override
  _PersonDetailsActivityState createState() => _PersonDetailsActivityState();
}

class _PersonDetailsActivityState extends State<PersonDetailsActivity> {
  final User? currentUser = Auth().currentUser;
  final String currentUserId = Auth().currentUser!.uid;
  bool isFollowed = false;

  List<dynamic>? followedPeople;

  Future<void> checkIsFollowed() async {
    isFollowed = false;
    followedPeople = await FirestoreService.getPeopleFollowed(currentUserId);
    if (followedPeople != null && followedPeople!.contains(widget.person.id)) {
      isFollowed = true;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkIsFollowed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Theme.of(context).colorScheme.primary)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.person.profilePath != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w780${widget.person.profilePath}',
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                'Biografia',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              ExpandableText(
                  text: widget.person.biography != null &&
                          widget.person.biography != ''
                      ? widget.person.biography!
                      : 'Non disponibile',
                  maxLines: 10),
              const Divider(),
              Text(
                'Data di nascita',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              Text(widget.person.birthday != null
                  ? widget.person.birthday!.split('-').reversed.join('/')
                  : 'Non disponibile'),
              const Divider(),
              Text(
                'Luogo di nascita',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              Text(widget.person.placeOfBirth ?? 'Non disponibile'),
              const Divider(),
              Text(
                'Genere',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              Text(getGenderText(widget.person.gender)),
              const Divider(),
              Text(
                widget.person.gender == null
                    ? 'Conosciuto per'
                    : (widget.person.gender == 1 ? 'Conosciuta per' : 'Conosciuto per'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 8),
              Text(getKnownFor(widget.person.knownFor)),
              widget.person.deathday != null && widget.person.deathday != ''
                  ? const Divider()
                  : const SizedBox.shrink(),
              widget.person.deathday != null && widget.person.deathday != ''
                  ? Text(
                      'Data di morte',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Theme.of(context).colorScheme.primary),
                    )
                  : const SizedBox.shrink(),
              widget.person.deathday != null && widget.person.deathday != ''
                  ? Text(widget.person.deathday!.split('-').reversed.join('/'))
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(isFollowed ? 'Segui già' : 'Segui'),
        onPressed: () {
          setState(() {
            if (isFollowed) {
              FirestoreService.unfollowPerson(currentUserId, widget.person.id);
              isFollowed = false;
            } else {
              FirestoreService.followPerson(currentUserId, widget.person.id);
              isFollowed = true;
            }
          });
        },
        icon: Icon(isFollowed ? Icons.check : Icons.add),
      ),
    );
  }

  String getGenderText(int? gender) {
    switch (gender) {
      case 0:
        return 'Non specificato';
      case 1:
        return 'Femminile';
      case 2:
        return 'Maschile';
      default:
        return 'Non disponibile';
    }
  }

  String getKnownFor(String? knownFor) {
    switch (knownFor) {
      case "Acting":
        return "Recitazione";
      case "Directing":
        return "Regia";
      case "Writing":
        return "Scrittura";
      case "Production":
        return "Produzione";
      case "Editing":
        return "Montaggio";
      case "Costume & Make-Up":
        return "Costumi e Trucco";
      case "Sound":
        return "Suono";
      case "Crew":
        return "Cast Tecnico";
      case "Visual Effects":
        return "Effetti Visivi";
      case "Camera":
        return "Fotografia";
      case "Lighting":
        return "Illuminazione";
      case "Creator":
        return "Creatore";
      default:
        return "Non disponibile";
    }
  }
}
