import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../login/Auth.dart';
import '../models/UserData.dart';

class FirestoreService {
  static FirebaseFirestore _db = FirebaseFirestore.instance;
  static CollectionReference _collectionUsers = _db.collection('users');
  static CollectionReference _collectionFollow = _db.collection('follow');
  static CollectionReference _collectionLists = _db.collection('lists');
  static CollectionReference _collectionEpisodes = _db.collection('episodes');
  static CollectionReference _collectionUsersReviews = _db.collection('usersReviews');
  static CollectionReference _collectionProductsReviews = _db.collection('productsReviews');

  static Future<dynamic> getUserByUid(String uid) async {
    print('Getting user with uid: $uid'); // x debug
    DocumentSnapshot snapshot = await _collectionUsers.doc(uid).get();
    print('Got user data: ${snapshot.data()}');  // Stampa i dati dell'utente x debug
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


      print('Utente creato con successo');
    } catch (error) {
      print('Errore durante la creazione dell\'utente: $error');
    }
  }


  // static Future<void> popolateUser(UserData userData) async {
  //   try{
  //     String uid= UserData.uid;
  //     // Conversione della data di nascita in un Timestamp
  //     Timestamp birthDate = Timestamp.fromDate(userData.dataNascita);
  //
  //   }
  // }



  static Future<List<dynamic>> searchUsers(String query) async {
    QuerySnapshot snapshot = await _collectionUsers
        .orderBy('username')
        .startAt([query])
        .endAt([query + '\uf8ff'])
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
    return lists?? null;
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

  // static Future<dynamic> getMovieRating(String uid, int movieId) async {
  //   DocumentSnapshot doc = await _collectionUsersReviews.doc(uid).get();
  //   double? ratingValueDoc = doc.get('movies.$movieId.rating.value');
  //   double ratingValue = ratingValueDoc?.toDouble() ?? 0;
  //   Timestamp? ratingTimestampDoc = doc.get('movies.$movieId.rating.timestamp');
  //   Timestamp ratingTimestamp = ratingTimestampDoc ?? Timestamp.now();
  //   return {'ratingValue': ratingValue, 'ratingTimestamp': ratingTimestamp};
  // }
  //
  // static Future<dynamic> getMovieReview(String uid, int movieId) async {
  //   DocumentSnapshot doc = await _collectionUsersReviews.doc(uid).get();
  //   String? reviewDoc = doc.get('movies.$movieId.review.text');
  //   String review = reviewDoc ?? '';
  //   Timestamp? reviewTimestampDoc =
  //   doc.get('movies.$movieId.review.timestamp');
  //   Timestamp reviewTimestamp = reviewTimestampDoc ?? Timestamp.now();
  //   return {'review': review, 'reviewTimestamp': reviewTimestamp};
  // }
  //
  // static Future<void> updateMovieRating(
  //     String uid, int movieId, double rating, Timestamp timestamp) async {
  //   DocumentReference docRef = _collectionUsersReviews.doc(uid);
  //   DocumentReference productsDocRef = _collectionProductsReviews.doc('movies');
  //   dynamic currentRating = await getMovieRating(uid, movieId);
  //   if (currentRating['ratingValue'] != 0) {
  //     docRef.update({'movies.$movieId.rating.value': rating});
  //     docRef.update({'movies.$movieId.rating.timestamp': timestamp});
  //     productsDocRef.update({
  //       '$movieId.value': FieldValue.increment(rating - currentRating['ratingValue'])
  //     });
  //   } else {
  //     docRef.update({
  //       'movies.$movieId.rating': {'value': rating, 'timestamp': timestamp}
  //     });
  //     productsDocRef.update({'$movieId.ratings': FieldValue.arrayUnion([uid])});
  //     productsDocRef.update({
  //       '$movieId.value': FieldValue.increment(rating)
  //     });
  //   }
  // }
  //
  // static Future<void> updateMovieReview(
  //     String uid, int movieId, String review, Timestamp timestamp) async {
  //   DocumentReference docRef = _collectionUsersReviews.doc(uid);
  //   DocumentReference productsDocRef = _collectionProductsReviews.doc('movies');
  //   dynamic currentReview = await getMovieReview(uid, movieId);
  //   if (currentReview['review'] != '') {
  //     docRef.update({'movies.$movieId.review.text': review});
  //     docRef.update({'movies.$movieId.review.timestamp': timestamp});
  //   } else {
  //     docRef.update({
  //       'movies.$movieId.review': {'text': review, 'timestamp': timestamp}
  //     });
  //     productsDocRef.update({'$movieId.reviews': FieldValue.arrayUnion([uid])});
  //   }
  // }
  //
  // static Future<dynamic> getSeriesRating(String uid, int seriesId) async {
  //   DocumentSnapshot doc = await _collectionUsersReviews.doc(uid).get();
  //   double? ratingValueDoc = doc.get('series.$seriesId.rating.value');
  //   double ratingValue = ratingValueDoc?.toDouble() ?? 0;
  //   Timestamp? ratingTimestampDoc = doc.get('series.$seriesId.rating.timestamp');
  //   Timestamp ratingTimestamp = ratingTimestampDoc ?? Timestamp.now();
  //   return {'ratingValue': ratingValue, 'ratingTimestamp': ratingTimestamp};
  // }
  //
  // static Future<dynamic> getSeriesReview(String uid, int seriesId) async {
  //   DocumentSnapshot doc = await _collectionUsersReviews.doc(uid).get();
  //   String? reviewDoc = doc.get('series.$seriesId.review.text');
  //   String review = reviewDoc ?? '';
  //   Timestamp? reviewTimestampDoc =
  //   doc.get('series.$seriesId.review.timestamp');
  //   Timestamp reviewTimestamp = reviewTimestampDoc ?? Timestamp.now();
  //   return {'review': review, 'reviewTimestamp': reviewTimestamp};
  // }
  //
  // static Future<void> updateSeriesRating(
  //     String uid, int seriesId, double rating, Timestamp timestamp) async {
  //   DocumentReference docRef = _collectionUsersReviews.doc(uid);
  //   DocumentReference productsDocRef = _collectionProductsReviews.doc('series');
  //   dynamic currentRating = await getSeriesRating(uid, seriesId);
  //   if (currentRating['ratingValue'] != 0) {
  //     docRef.update({'series.$seriesId.rating.value': rating});
  //     docRef.update({'series.$seriesId.rating.timestamp': timestamp});
  //     productsDocRef.update({
  //       '$seriesId.value': FieldValue.increment(rating - currentRating['ratingValue'])
  //     });
  //   } else {
  //     docRef.update({
  //       'series.$seriesId.rating': {'value': rating, 'timestamp': timestamp}
  //     });
  //     productsDocRef.update({'$seriesId.ratings': FieldValue.arrayUnion([uid])});
  //     productsDocRef.update({
  //       '$seriesId.value': FieldValue.increment(rating)
  //     });
  //   }
  // }
  //
  // static Future<void> updateSeriesReview(
  //     String uid, int seriesId, String review, Timestamp timestamp) async {
  //   DocumentReference docRef = _collectionUsersReviews.doc(uid);
  //   DocumentReference productsDocRef = _collectionProductsReviews.doc('series');
  //   dynamic currentReview = await getSeriesReview(uid, seriesId);
  //   if (currentReview['review'] != '') {
  //     docRef.update({'series.$seriesId.review.text': review});
  //     docRef.update({'series.$seriesId.review.timestamp': timestamp});
  //   } else {
  //     docRef.update({
  //       'series.$seriesId.review': {'text': review, 'timestamp': timestamp}
  //     });
  //     productsDocRef.update({'$seriesId.reviews': FieldValue.arrayUnion([uid])});
  //   }
  // }

  // static Future<double> getAverageMovieRating(int movieId) async {
  //   DocumentSnapshot docRef = await _collectionProductsReviews.doc('movies').get();
  //   double value = 0;
  //   List<dynamic> users = [];
  //   Map<String, dynamic> data = docRef.data() ?? {};
  //   if (data.containsKey('$movieId.ratings')) {
  //     users = data['$movieId.ratings'];
  //   }
  //   if (data.containsKey('$movieId.value')) {
  //     value = data['$movieId.value'].toDouble();
  //   }
  //   if (users.isEmpty) {
  //     return 0;
  //   }
  //   return value / users.length;
  // }

  // static Future<double> getAverageSeriesRating(int seriesId) async {
  //   DocumentSnapshot docRef =
  //   await _collectionProductsReviews.doc('series').get();
  //   double value = 0;
  //   List<dynamic> users = [];
  //   Map<String, dynamic> data = docRef.data() ?? {};
  //   if (data.containsKey('$seriesId.ratings')) {
  //     users = data['$seriesId.ratings'];
  //   }
  //   if (data.containsKey('$seriesId.value')) {
  //     value = data['$seriesId.value'].toDouble();
  //   }
  //   if (users.isEmpty) {
  //     return 0;
  //   }
  //   return value / users.length;
  // }

  // static Future<List<dynamic>> getMovieReviews(int movieId) async {
  //   DocumentSnapshot docRef =
  //   await _collectionProductsReviews.doc('movies').get();
  //   List<dynamic> users = [];
  //   Map<String, dynamic> data = docRef.data() ?? {};
  //   if (data.containsKey('$movieId.reviews')) {
  //     users = data['$movieId.reviews'];
  //   }
  //   List<dynamic> reviews = [];
  //   for (String user in users) {
  //     dynamic userData = await getUserByUid(user);
  //     dynamic reviewData = await getMovieReview(user, movieId);
  //     DateTime date = reviewData['reviewTimestamp'].toDate();
  //     String dateString =
  //         '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  //     Map<String, dynamic> review = {
  //       'userData': userData,
  //       'reviewText': reviewData['review'],
  //       'reviewDate': dateString,
  //     };
  //     reviews.add(review);
  //   }
  //   return reviews;
  // }
  //
  static Future<List<dynamic>> getAllRatings(String type) async {
    DocumentSnapshot docRef =
    await _collectionProductsReviews.doc(type).get();
    Map<String, dynamic> data = docRef.data() as Map<String, dynamic> ?? {};
    List<dynamic> ratings = [];
    for (String movieId in data.keys) {
      if (data[movieId]['ratings'] == null) {
        continue;
      }
      double rating =
          data[movieId]['value'].toDouble() / data[movieId]['ratings'].length;
      ratings.add({'movieId': int.parse(movieId), 'rating': rating});
    }
    return ratings;
  }

  // static Future<List<dynamic>> getSeriesReviews(int seriesId) async {
  //   DocumentSnapshot docRef =
  //   await _collectionProductsReviews.doc('series').get();
  //   List<dynamic> users = [];
  //   Map<String, dynamic> data = docRef.data() ?? {};
  //   if (data.containsKey('$seriesId.reviews')) {
  //     users = data['$seriesId.reviews'];
  //   }
  //   List<dynamic> reviews = [];
  //   for (String user in users) {
  //     dynamic userData = await getUserByUid(user);
  //     dynamic reviewData = await getSeriesReview(user, seriesId);
  //     DateTime date = reviewData['reviewTimestamp'].toDate();
  //     String dateString =
  //         '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  //     Map<String, dynamic> review = {
  //       'userData': userData,
  //       'reviewText': reviewData['review'],
  //       'reviewDate': dateString,
  //     };
  //     reviews.add(review);
  //   }
  //   return reviews;
  // }

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
        // Aggiungi altri campi dati se necessario
      });
      // Caricamento dati completato con successo
    } catch (error) {
      // Si è verificato un errore durante il caricamento dei dati
      print(error);
      // Gestisci l'errore di conseguenza
    }
  }
}
