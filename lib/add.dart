import 'package:flutter/material.dart';
import 'package:notas/firebase/firebase.dart';
//import 'package:image_picker/image_picker.dart';

class AddNotasDialog extends StatefulWidget {
  final String name;
  final String descripcion;
  final String titulo;

  final String docId;

  AddNotasDialog({this.name, this.docId, this.descripcion, this.titulo});

  @override
  _AddNotasDialogState createState() => _AddNotasDialogState();
}

class _AddNotasDialogState extends State<AddNotasDialog> {
  final _formAddPlayerKey = GlobalKey<FormState>();
  String descripcion;
  String titulo;
//  Future<File> _imageFile;

  String validateName(String value) {
    if (value.isEmpty) {
      return "No puede estar vacio";
    } else {
      return null;
    }
  }

//  Widget _previewImage() {
//    return FutureBuilder<File>(
//        future: _imageFile,
//        builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
//          if (snapshot.connectionState == ConnectionState.done &&
//              snapshot.data != null) {
//            return Image.file(snapshot.data);
//          } else if (snapshot.error != null) {
//            return const Text(
//              'Error picking image.',
//              textAlign: TextAlign.center,
//            );
//          } else {
//            return const Text(
//              'You have not yet picked an image.',
//              textAlign: TextAlign.center,
//            );
//          }
//        });
//  }

//  getImage(){
//    _imageFile = ImagePicker.pickImage(source: ImageSource.gallery);
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Form(
            key: _formAddPlayerKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Titulo',labelStyle: TextStyle(fontSize: 30,),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  keyboardType: TextInputType.text,
                  initialValue:
                      widget.titulo != null && widget.titulo.isNotEmpty
                          ? widget.titulo
                          : "",
                  validator: (value) {
                    return validateName(value);
                  },
                  onSaved: (value) => titulo = value,
                ),
                SizedBox(
                  height: 20,
                ),

                FlatButton(
                  color: Colors.blueGrey[600],
                  onPressed: () {
                    final form = _formAddPlayerKey.currentState;
                    if (form.validate()) {
                      form.save();
                      if ((widget.titulo != null && widget.titulo.isNotEmpty) &&
                          (widget.descripcion != null &&
                              widget.descripcion.isNotEmpty)) {
                        FireBaseAPI.updateNotas(
                            widget.docId, titulo, descripcion);
                      } else {
                        FireBaseAPI.addNotas(titulo, descripcion);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    widget.name != null && widget.name.isNotEmpty
                        ? "Actualizar"
                        : 'Guardar',
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(color: Colors.white),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
