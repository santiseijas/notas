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
        // Define the default Brightness and Colors
        brightness: Brightness.dark,
        splashColor: Colors.black12,
        primaryColor: Colors.blueGrey[600],
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
        centerTitle: true,
        elevation: 20,
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
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
    return FloatingActionButton(mini: true,backgroundColor: Colors.blueGrey[600],
      elevation: 0,
      heroTag: null,
      onPressed: () {
        _navigateToAddNotas();
      },
      child: Icon(Icons.add,color: Colors.white,),
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
                _buildPlayerList(context, snapshot.data.documents),
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

  Widget _buildPlayerList(
      BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 20.0),
      children:
          snapshot.map((data) => _buildPlayerItem(context, data)).toList(),
    );
  }

  Widget _buildPlayerItem(BuildContext context, DocumentSnapshot data) {
    final player = Player.fromSnapshot(data);
    return Card(
        color: Colors.black12,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Column(
          children: <Widget>[
            Text(
              player.titulo,
              style: TextStyle(fontSize: 50),
            ),
            Text(player.descripcion),
            Row(
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
                          name: player.titulo,
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  child: Icon(Icons.edit),
                ),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.red,
                  heroTag: null,
                  onPressed: () {
                    _buildConfirmationDialog(context, data.documentID);
                  },
                  child: Icon(Icons.delete),
                ),
              ],
            ),
          ],
        ));
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
