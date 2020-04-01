import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseAPI {
  static Stream<QuerySnapshot> notasStream =
      Firestore.instance.collection('notas').snapshots();

  static CollectionReference reference =
  Firestore.instance.collection('notas');

  static addNotas(String titulo,String descripcion) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.add({
        "titulo": titulo,
        "descripcion": descripcion,
      });
    });
  }

  static removeNotas(String id) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).delete().catchError((error) {
        print(error);
      });
    });
  }

  static updateNotas(String id, String newTitulo, String newDes) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).updateData({
        "titulo": newTitulo,
        "descripcion": newDes,
      }).catchError((error) {
        print(error);
      });
    });
  }


}
