import 'package:cloud_firestore/cloud_firestore.dart';

class Notas {
  final String titulo;
  final String descripcion;
  bool check;
  final DocumentReference reference;

  Notas.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['titulo'] != null),
        titulo = map['titulo'],
        descripcion = map['descripcion'],
        check = map['check'];

  Notas.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => titulo;
}
