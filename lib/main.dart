import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart'; // dependencies: social_share: ^2.0.5

void main() {
  runApp(MaterialApp(
      title: 'Lista',
      debugShowCheckedModeBanner: false,
      home: MainApp(),
      theme: ThemeData(
          primaryColor: Colors.brown[800],
          primaryColorDark: Colors.brown[900],
          cursorColor: Colors.deepOrangeAccent)));
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _formKey = GlobalKey<FormState>();
  var _itemController = TextEditingController();
  List _lista = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              var itens =
                  _lista.reduce((value, element) => value + '\n' + element);
              SocialShare.shareWhatsapp("Lista de Tarefas:\n" + itens)
                  .then((data) {
                //print(data);
              });
            },
          )
        ],
      ),
      body: Scrollbar(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            for (int i = 0; i < _lista.length; i++)
              ListTile(
                  leading: ExcludeSemantics(
                    child: CircleAvatar(
                        backgroundColor: Colors.deepOrangeAccent,
                        child: Text(
                          '${i + 1}',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark),
                        )),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _lista[i].toString(),
                          style: TextStyle(color: Colors.deepOrangeAccent),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 20.0,
                          color: Colors.red[900],
                        ),
                        onPressed: () {
                          setState(() {
                            _lista.removeAt(i);
                          });
                        },
                      ),
                    ],
                  )),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColorDark,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: () => _displayDialog(context),
      ),
    );
  }

  _displayDialog(context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Form(
              key: _formKey,
              child: TextFormField(
                controller: _itemController,
                validator: (s) {
                  if (s.isEmpty)
                    return "Insira uma tarefa.";
                  else
                    return null;
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Tarefa"),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.deepOrangeAccent,
                child: new Text('CANCELAR'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                color: Colors.deepOrangeAccent,
                child: new Text('SALVAR'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      _lista.add(_itemController.text);
                      _itemController.text = "";
                    });
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }
}
