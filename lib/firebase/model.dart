import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  final String titulo;
  final String descripcion;
  final DocumentReference reference;

  Player.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['titulo'] != null),
        titulo = map['titulo'],
        descripcion = map['descripcion'];
  Player.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => titulo;


}
