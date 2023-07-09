import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../login/Auth.dart';
import '../models/UserData.dart';

class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  //riferimenti alle collezioni del database
  static final CollectionReference _collectionUsers = _db.collection('users');
  static final CollectionReference _collectionFollow = _db.collection('follow');
  static final CollectionReference _collectionLists = _db.collection('lists');
  static final CollectionReference _collectionEpisodes = _db.collection('episodes');
  static final CollectionReference _collectionUsersReviews = _db.collection('usersReviews');
  static final CollectionReference _collectionProductsReviews = _db.collection('productsReviews');

  static Future<dynamic> getUserByUid(String uid) async {
    DocumentSnapshot snapshot = await _collectionUsers.doc(uid).get();
    return snapshot.data();
  }
  static Future<bool> searchUsersByEmail(String email) async {
    QuerySnapshot snapshot = await _collectionUsers
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return snapshot.size > 0;

  }
  static Future<void> createUser(UserData userData) async {
    try {
		//qui creo l'utente con mail e password
      await Auth().createUserWithEmailAndPassword(email: userData.email, password: userData.password);
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: userData.email,
        password: userData.password,
      );
		//prendo id dell'utente creato
      String uid= userCredential.user!.uid;
      // Conversione della data di nascita in un Timestamp
      Timestamp birthDate = Timestamp.fromDate(userData.dataNascita);
		//questa parte serve per l'immagine profilo
      final compressedImage = await userData.avatar.readAsBytes();
      final compressedImageData = await FlutterImageCompress.compressWithList(
        compressedImage,
        minHeight: 500,
        minWidth: 500,
        quality: 80,
      );
			//prende il riferimento a Firebase storage
      final storageReference = FirebaseStorage.instance.ref();
			//crea il riferimento all'immagine che verrà caricata
      final propicReference = storageReference.child("propic/$uid/profile.jpg");
			//la carica
      final uploadTask = propicReference.putData(compressedImageData);
      final snapshot = await uploadTask.whenComplete(() {});
			//prende il link all'immagine sul server
      final propicURL = await propicReference.getDownloadURL();

      // Creazione dei dati utente da salvare nel documento
			//creo una mappa che verrà caricata sul db
			//nello specifico questa è per gli attributi dell'utente
      Map<String, dynamic> userDataMap = {
        'backdropImage': "https://image.tmdb.org/t/p/w1280//chauy3iJaZtrMbTr72rgNmOZwo3.jpg",
        'birthDate': birthDate,
        'email': userData.email,
        'gender': userData.genere,
        'nameShown': userData.nomeVisualizzato,
        'profileImage': propicURL,
        'uid': uid,
        'username': userData.nomeUtente,
        'movieMinutes': 0,
        'moviesNumber':0,
        'tvMinutes':0,
        'tvNumber':0
      };
			//prende l id utente (perché due volte?)
      DocumentReference userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      // Salvataggio della mappa con i dati utente nel documento
      await userRef.set(userDataMap);
      // Inizio creazione delle varie mappe per i dati da salvare nel documento

      // mappa per i follow
      Map<String, dynamic> followDataMap = {
        'followers': [],
        'following': [],
        'people': [],
      };
      DocumentReference followRef = FirebaseFirestore.instance.collection('follow').doc(uid);
      await followRef.set(followDataMap);

      //mappa per le liste
      Map<String, dynamic> listDataMap = {
        'favorite_m': [],
        'favorite_t': [],
        'finished_t': [],
        'watched_m': [],
        'watching_t': [],
        'watchlist_m': [],
        'watchlist_t': [],
      };
      DocumentReference listsRef = FirebaseFirestore.instance.collection('lists').doc(uid);
      await listsRef.set(listDataMap);

      // mappa per gli espisodi
      Map<String, dynamic> watchingSeriesMap = {
        'watchingSeries': <String, dynamic>{},
      };

      DocumentReference watchingSeriesRef = FirebaseFirestore.instance.collection('episodes').doc(uid);
      await watchingSeriesRef.set(watchingSeriesMap);

      Map<String, dynamic> reviewsDocument = {
        "movies": <String, Map<String, Map<String, dynamic>>>{},
        "series": <String, dynamic>{},
      };

      DocumentReference reviewsRef = FirebaseFirestore.instance.collection('usersReviews').doc(uid);
      await reviewsRef.set(reviewsDocument);

    } catch (error) {
      print('Error durante la creation dell\'utente: $error'); // lasciamo importante
    }
  }

  static Future<List<dynamic>> searchUsers(String query) async {
    QuerySnapshot snapshot = await _collectionUsers
        .orderBy('username')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  static Query getWhereEqualTo(String collection, String field, String value) {
    return _db.collection(collection).where(field, isEqualTo: value);
  }

  static Future<void> updateUserField(
      String uid, String field, dynamic value, Function(bool) callback) async {
    DocumentReference userRef = _collectionUsers.doc(uid);
    try {
      await userRef.update({field: value});
      callback(true);
    } catch (e) {
      callback(false);
    }
  }

  static Future<List<String>> getFollowers(String uid) async {
    DocumentSnapshot doc = await _collectionFollow.doc(uid).get();
    List<dynamic> followers = doc.get('followers');
    return followers.cast<String>();
  }

  static Future<List<String>> getFollowing(String uid) async {
    DocumentSnapshot doc = await _collectionFollow.doc(uid).get();
    List<dynamic> following = doc.get('following');
    return following.cast<String>();
  }

  static Future<List<dynamic>> getPeopleFollowed(String uid) async {
    DocumentSnapshot doc = await _collectionFollow.doc(uid).get();
    List<dynamic> people = doc.get('people');
    return people.cast<dynamic>();
  }

  static Future<void> followUser(String uid, String targetUid) async {
    DocumentReference followRef = _collectionFollow.doc(uid);
    await followRef.update({'following': FieldValue.arrayUnion([targetUid])});

    DocumentReference followerRef = _collectionFollow.doc(targetUid);
    await followerRef.update({'followers': FieldValue.arrayUnion([uid])});
  }

  static Future<void> unfollowUser(String uid, String targetUid) async {
    DocumentReference followRef = _collectionFollow.doc(uid);
    await followRef.update({'following': FieldValue.arrayRemove([targetUid])});

    DocumentReference followerRef = _collectionFollow.doc(targetUid);
    await followerRef.update({'followers': FieldValue.arrayRemove([uid])});
  }

  static Future<void> followPerson(String uid, int personId) async {
    DocumentReference followRef = _collectionFollow.doc(uid);
    await followRef.update({'people': FieldValue.arrayUnion([personId])});
  }

  static Future<void> unfollowPerson(String uid, int personId) async {
    DocumentReference followRef = _collectionFollow.doc(uid);
    await followRef.update({'people': FieldValue.arrayRemove([personId])});
  }

  static Future<void> addToList(String uid, String listName, int itemId) async {
    DocumentReference listsRef = _collectionLists.doc(uid);
    await listsRef.update({listName: FieldValue.arrayUnion([itemId])});
  }

  static Future<void> removeFromList(
      String uid, String listName, int itemId) async {
    DocumentReference listsRef = _collectionLists.doc(uid);
    await listsRef.update({listName: FieldValue.arrayRemove([itemId])});
  }

  static Future<List<dynamic>> getList(String uid, String listName) async {
    DocumentSnapshot doc = await _collectionLists.doc(uid).get();
    List<dynamic> list = doc.get(listName);
    return list.cast<dynamic>();
  }

  static Future<Object?> getLists(String uid) async {
    DocumentSnapshot doc = await _collectionLists.doc(uid).get();
    Object? lists = doc.data();
    return lists;
  }

  static Future<void> addSeriesToWatching(String uid, int seriesId) async {
    DocumentReference docRef = _collectionEpisodes.doc(uid);

    Map<String, dynamic> initialSeriesData = {};
    docRef.update({'watchingSeries.$seriesId': initialSeriesData});
  }

  static Future<void> addWatchedEpisode(
      String uid, int seriesId, int seasonNumber, int episodeNumber) async {
    DocumentReference docRef = _collectionEpisodes.doc(uid);
    docRef.update({
      'watchingSeries.$seriesId.$seasonNumber':
      FieldValue.arrayUnion([episodeNumber])
    });
  }

  static Future<void> removeEpisodeFromWatched(
      String uid, int seriesId, int seasonNumber, int episodeNumber) async {
    DocumentReference docRef = _collectionEpisodes.doc(uid);
    docRef.update({
      'watchingSeries.$seriesId.$seasonNumber':
      FieldValue.arrayRemove([episodeNumber])
    });
  }

  static Future<bool> checkIfEpisodeWatched(
      String uid, int seriesId, int seasonNumber, int episodeNumber) async {
    DocumentSnapshot doc = await _collectionEpisodes.doc(uid).get();
    Map<String, dynamic>? series = doc.get('watchingSeries.$seriesId');
    List<dynamic>? season = series?[seasonNumber.toString()];
    bool isWatched = season?.contains(episodeNumber) ?? false;
    return isWatched;
  }

  static Future<Map<String, dynamic>> getWatchingSeries(String uid) async {
    DocumentSnapshot doc = await _collectionEpisodes.doc(uid).get();
    Map<String, dynamic> watchingSeries = doc.get('watchingSeries');
    return watchingSeries;
  }

  static Future<List<dynamic>> getAllRatings(String type) async {
    DocumentSnapshot docRef =
    await _collectionProductsReviews.doc(type).get();
    Map<String, dynamic> data = docRef.data() as Map<String, dynamic> ?? {};
    List<dynamic> ratings = [];
    for (String id in data.keys) {
      if (data[id]['ratings'] == null) {
        continue;
      }
      double rating =
          data[id]['value'].toDouble() / data[id]['ratings'].length;
      ratings.add({'id': int.parse(id), 'rating': rating});
    }
    return ratings;
  }

  static Future<Map<String, dynamic>?> getUserReviews(String userId, String type) async {
    DocumentSnapshot docRef =
    await _collectionUsersReviews.doc(userId).get();
    Map<String, dynamic>? reviews = docRef.get(type);
    Map<String, dynamic>? latestReview = findLatestReview(reviews);
    if (latestReview == null) {
      return null;
    }
    dynamic userData = await getUserByUid(userId);
    DateTime date = DateTime.parse(latestReview['reviewDate']);
    String dateString =
        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    Map<String, dynamic> reviewTriple = {
      'userData': userData,
      'reviewText': latestReview['review'],
      'reviewDate': dateString,
    };
    return {'reviewTriple': reviewTriple, 'latestReview': latestReview['movieId']};
  }

  static Map<String, dynamic>? findLatestReview(Map<String, dynamic>? reviews) {
    Map<String, dynamic>? latestReview;
    Timestamp? latestTimestamp;

    for (String key1 in reviews!.keys) {
      Map<String, dynamic>? value1 = reviews[key1];
      Map<String, dynamic>? value2 = value1!['review'];
      Timestamp timestamp = value2!['timestamp'];
      if (latestTimestamp == null || timestamp.compareTo(latestTimestamp) > 0) {
        latestTimestamp = timestamp;
        DateTime date = latestTimestamp.toDate();
        String dateString =
            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
        latestReview = {
          'movieId': key1,
          'review': value2['text'],
          'reviewDate': dateString,
        };
      }
    }
    return latestReview;
  }

  static Future<void> saveUserData(UserData userData) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userData.email)
          .set({
        'username': userData.nomeUtente,
        'gender': userData.genere,
        'birthDate': userData.dataNascita,
        'nameShown': userData.nomeVisualizzato,
      });
      // Caricamento dati completato con successo
    } catch (error) {
      // Si è verificato un errore durante il caricamento dei dati
      print(error);
      // Gestisci l'errore di conseguenza
    }
  }
}
