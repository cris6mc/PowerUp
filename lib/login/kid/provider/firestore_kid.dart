import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jueguito2/game/my_game.dart';

FirebaseFirestore get firestore => FirebaseFirestore.instance;

User get currentUser {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Not authenticated Exception');
  return user;
}

Future<void> saveKid(String? name, String? description, String? gender,
    DateTime? birtday, String? ie, Map? valores, Map? antivalores) async {
  firestore.collection('users').doc(currentUser.uid).update({
    'kids': FieldValue.arrayUnion([
      {
        // crear un el id del kid
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'name': name,
        'description': description,
        'gender': gender,
        'birtday': birtday,
        'ie': ie,
        'valores': valores,
        'antivalores': antivalores,
      }
    ])
  });
}

//get kid
Future<Map<String, dynamic>> getKid(int? index) async {
  Map<String, dynamic> kid = {};
  await firestore
      .collection('users')
      .doc(currentUser.uid)
      .get()
      .then((value) => kid = value.data() ?? {});
  return kid;
}

Future<void> deleteKid(int index) async {
  final DocumentReference documentReference =
      FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
  DocumentSnapshot documentSnapshot = await documentReference.get();
  if (documentSnapshot.exists) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    List array = data['kids'];
    array.removeAt(index);
    await documentReference.update({'kids': array});
  }
}

Future<void> updateKidDescription(int index, String? description) async {
  final DocumentReference documentReference =
      FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
  DocumentSnapshot documentSnapshot = await documentReference.get();
  if (documentSnapshot.exists) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    List<Map<String, dynamic>> array = data['kids'];
    array[index]['description'] = description;
    await documentReference.update({'kids': array});
  }
}

Future<void> updateKidValores(int index, Map<ValuesType, int> valores,
    Map<AntiValuesType, int> antivalores) async {
  Map<String, int> convertedValores =
      valores.map((key, value) => MapEntry(key.toString(), value));

  Map<String, int> convertedAntiValores =
      antivalores.map((key, value) => MapEntry(key.toString(), value));

  final DocumentReference documentReference =
      FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
  DocumentSnapshot documentSnapshot = await documentReference.get();
  if (documentSnapshot.exists) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    List array = data['kids'];
    array[index]['valores'] = convertedValores;
    array[index]['antivalores'] = convertedAntiValores;
    await documentReference.update({'kids': array});
  }
}
