import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore get firestore => FirebaseFirestore.instance;

User get currentUser {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) throw Exception('Not authenticated Exception');
  return user;
}

Future<void> saveKid(String? name, String? description, String? gender,
    DateTime? birtday, String? ie, Map? valores, Map? antivalores) async {
  Future<DocumentReference> n = firestore
      .collection('users')
      .doc(currentUser.uid)
      .collection('kids')
      .add({
    'name': name,
    'description': description,
    'gender': gender,
    'birtday': birtday,
    'ie': ie,
    'valores': valores,
    'antivalores': antivalores,
  });
  await n.then(
      (value) => firestore.collection('users').doc(currentUser.uid).update({
            'kids': FieldValue.arrayUnion([
              {'id': value.id, 'name': name}
            ])
          }));
}

//get kid
Future<Map<String, dynamic>> getKid(String? id) async {
  Map<String, dynamic> kid = {};
  await firestore
      .collection('users')
      .doc(currentUser.uid)
      .collection('kids')
      .doc(id)
      .get()
      .then((value) => kid = value.data() ?? {});
  return kid;
}

Future<void> deleteKid(String? id) async {
  await firestore
      .collection('users')
      .doc(currentUser.uid)
      .collection('kids')
      .doc(id)
      .delete();
  // final DocumentReference documentReference =
  //     FirebaseFirestore.instance.collection('tu_coleccion').doc(currentUser.uid);
  // DocumentSnapshot documentSnapshot = await documentReference.get();
  // if (documentSnapshot.exists) {
  //   // 3. Obtiene el array actual del documento
  //   List<Map<String, dynamic>> array =
  //       List<Map<String, dynamic>>.from(documentSnapshot.data()?['kids']);

  //   // 4. Busca el mapa con el 'id' proporcionado
  //   int indexToRemove = array.indexWhere((map) => map['id'] == id);

  //   if (indexToRemove != -1) {
  //     // 5. Elimina el mapa del array
  //     array.removeAt(indexToRemove);

  //     // 6. Guarda los cambios actualizados en el documento
  //     await documentReference.update({'kids': array});
  //   }
  // }
}

Future<void> updateKidDescription(String? id, String? description) async {
  await firestore
      .collection('users')
      .doc(currentUser.uid)
      .collection('kids')
      .doc(id)
      .update({
    'description': description,
  });
}
