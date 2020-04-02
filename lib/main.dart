import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notas/add.dart';
import 'package:notas/firebase/firebase.dart';
import 'package:notas/firebase/model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        dividerColor: Colors.transparent,
        // Define the default Brightness and Colors
        brightness: Brightness.dark,
        accentColor: Colors.grey,
        // Define the default Font Family
        fontFamily: 'Raleway',
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        centerTitle: true,
        elevation: 10,
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
        title: Text(
          "Notas",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 36,
          ),
        ),
        actions: <Widget>[buildAddPlayerFab()],
      ),
      body: SafeArea(child: _buildBody(context)),
    );
  }

  buildAddPlayerFab() {
    return FloatingActionButton(
      mini: true,
      backgroundColor: Colors.grey[800],
      elevation: 0,
      heroTag: null,
      onPressed: () {
        _navigateToAddNotas();
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FireBaseAPI.notasStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        if (snapshot.data.documents.length > 0) {
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 15),
                  child: Text(
                    "${snapshot.data.documents.length.toString()} Notas",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                _buildList(context, snapshot.data.documents),
              ],
            ),
          );
        } else {
          return Center(
            child: Text(
              "No hay ninguna nota ",
              style: Theme.of(context).textTheme.title,
            ),
          );
        }
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 5.0),
      children: snapshot.map((data) => _buildItem(context, data)).toList(),
    );
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot data) {
    final notas = Notas.fromSnapshot(data);

    return notas.descripcion == null
        ? Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: <Widget>[
                Container(
                  height: 80,
                  child: buildTitle(notas, context, data),
                ),
              ],
            ),
          )
        : Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: <Widget>[
                ExpansionTile(
                  title: Row(
                    children: <Widget>[
                      Container(
                        height: 70,
                        child: Checkbox(
                          tristate: false,
                          checkColor: Colors.black,
                          activeColor: Colors.white,
                          onChanged: (val) {
                            setState(() {
                              FireBaseAPI.updateCheck(data.documentID, val);
                            });
                          },
                          value: notas.check,
                        ),
                      ),
                      Container(
                        width: 200,
                        child: Text(
                          notas.titulo,
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.list,
                    color: Colors.white,
                    size: 40,
                  ),
                  children: <Widget>[ListTile(leading: Icon(Icons.control_point,size: 10,),title: Text(notas.descripcion))],
                )
              ],
            ),
          );
  }

  Row buildTitle(Notas notas, BuildContext context, DocumentSnapshot data) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 15),
          child: Checkbox(
            tristate: false,
            checkColor: Colors.black,
            activeColor: Colors.white,
            onChanged: (val) {
              setState(() {
                FireBaseAPI.updateCheck(data.documentID, val);
              });
            },
            value: notas.check,
          ),
        ),
        Container(
          width: 200,
          child: Text(
            notas.titulo,
            style: TextStyle(
              fontSize: 25,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 5),
          child: Row(
            children: <Widget>[
              FloatingActionButton(
                mini: true,
                heroTag: null,
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddNotasDialog(
                        docId: data.documentID,
                        name: notas.titulo,
                      ),
                      fullscreenDialog: true,
                    ),
                  );
                },
                child: Icon(
                  Icons.edit,
                  color: Colors.black,
                ),
              ),
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.red,
                heroTag: null,
                onPressed: () {
                  _buildConfirmationDialog(context, data.documentID);
                },
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> _buildConfirmationDialog(
      BuildContext context, String documentID) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Borrar'),
          content: Text('Quieres borrar esta nota?'),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
                child: Text('Borrar'),
                onPressed: () {
                  FireBaseAPI.removeNotas(documentID);
                  Navigator.of(context).pop(true);
                }),
          ],
        );
      },
    );
  }

  void _navigateToAddNotas() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddNotasDialog(),
        fullscreenDialog: true,
      ),
    );
  }
}
