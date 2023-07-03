
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filmaccio_flutter/widgets/Firebase/FirestoreService.dart';
import 'package:flutter/material.dart';

import '../other_user_profile.dart';

class Ricerca extends StatefulWidget {
  @override
  _RicercaState createState() => _RicercaState();

}

class _RicercaState extends State<Ricerca> {
  final TextEditingController _searchController = TextEditingController();
  Stream<QuerySnapshot>? _usersStream;

  // implento una variabile booleana per sapere se sto cercando o meno
  bool _isSearching = false;

  void _search() {
    final String searchText = _searchController.text.trim();
    if (searchText.isNotEmpty) {
      _isSearching = true;
      _usersStream = FirebaseFirestore.instance
      // query che mi fa la ricerca, mi fa un ceck se inizia o finisce con la stringa cercata
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: searchText)
          .where('username', isLessThanOrEqualTo: searchText + '\uf8ff')
          .snapshots();
    } else {
      _isSearching = false;
      _usersStream = null; //  questa riga per ripulire lo stream dei dati degli utenti
    }
    setState(() {});
  }
  void _openOtherUserProfile(String userId, String id) {

    // per aprire la pagina di un utente cercato
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherUserProfile(userId: userId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ricerca'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(16),
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

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                    String userId = data['uid']; // Utilizzo il campo 'uid' invece di 'userId'
                    return ListTile(
                      title: Text(data['username']),
                      subtitle: Text(data['nameShown']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherUserProfile(userId: userId),
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
          if (!_isSearching) // Mostra solo se non si sta cercando
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Text(
                        'Film consigliati',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: 16),
                          Container(
                            width: 110,
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 110,
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 110,
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Text(
                        'Serie consigliate',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: 16),
                          Container(
                            width: 110,
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 110,
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 110,
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Text(
                        'Film in tendenza',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: 16),
                          Container(
                            width: 110,
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 110,
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 110,
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Text(
                        'Serie in tendenza',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(width: 16),
                          Container(
                            width: 110,
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 110,
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            width: 110,
                            height: 165,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 16),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
