import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'other_user_profile.dart';

class Ricerca extends StatefulWidget {
  @override
  _RicercaState createState() => _RicercaState();
}

class _RicercaState extends State<Ricerca> {
  final TextEditingController _searchController = TextEditingController();
  Stream<QuerySnapshot>? _usersStream;

  void _search() {
    final String searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      _usersStream = FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: searchText)
          .where('username', isLessThanOrEqualTo: searchText + '\uf8ff')
          .snapshots();
    } else {
      _usersStream = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 80, 16, 0),
            child: Text(
              'Ricerca',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cerca...',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _search,
                ),
              ),
            ),
          ),
          Expanded(
            child: _usersStream != null
                ? StreamBuilder<QuerySnapshot>(
                    stream: _usersStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Errore: ${snapshot.error}');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          String userId = data['uid'];
                          return ListTile(
                            title: Text(data['username']),
                            subtitle: Text(data['nameShown']),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(data['profileImage']),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      OtherUserProfile(userId),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      );
                    },
                  )
                : Container(),
          ),
        ],
      ),
    );
  }
}