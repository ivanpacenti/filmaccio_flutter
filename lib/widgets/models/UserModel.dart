class UserModel {
  final String uid;
  final String nameShown;
  final String email;

  UserModel({required this.uid, required this.nameShown, required this.email});

  // Creare un'istanza di UserModel da un oggetto Map
  factory UserModel.fromMap(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      nameShown: data['nameShown'] ?? '',  // gestisci il caso in cui `nameShown` potrebbe non esistere
      email: data['email'] ?? '',  // gestisci il caso in cui `email` potrebbe non esistere
    );
  }

  // Convertire un'istanza di UserModel in un oggetto Map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'nameShown': nameShown,
      'email': email,
    };
  }
}
