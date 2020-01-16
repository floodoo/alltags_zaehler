import 'dart:developer';

import 'package:alltags_zaehler/countButton.obj.dart';
import 'package:alltags_zaehler/speichern.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pref_dessert/pref_dessert_internal.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alltagszähler',
      home: ChangeNotifierProvider(
        create: (context) => CounterState(),
        child: MyCounter(),
      ),
    );
  }
}

class MyCounter extends StatefulWidget {
  final List<CountButton> buttons = [
    CountButton(
      name: 'Bier',
      message: 'Du hast schon wieder Bier getrunken?!',
      icon: "glass-mug-variant",
      color: Colors.limeAccent[400],
    ),
    CountButton(
      name: 'Zigarette',
      message: 'Du warst wieder Rauchen?!',
      icon: "smoking",
      color: Colors.limeAccent[400],
    ),
    CountButton(
        name: 'Kaffee',
        message: 'Du trinkst schon wieder Kaffee?!',
        icon: "coffee",
        color: Colors.limeAccent[400]),
  ];

  final repo =
      new FuturePreferencesRepository<CountButtonObj>(new CountButtonDesSer());

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyCounter> {
  @override
  void initState() {
    createObjectsFromRepo();

    super.initState();
  }

  createObjectsFromRepo() async {
    List<CountButtonObj> buttonObjs = await widget.repo.findAll();
    for (CountButtonObj countbuttonobject in buttonObjs) {
      CountButton button = CountButton(
        color: Color(countbuttonobject.color),
        name: countbuttonobject.name,
        message: countbuttonobject.message,
        icon: countbuttonobject.icon,
      );

      widget.buttons.add(button);
    }
  }

  void createDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Was möchtest du Zählen?'),
            backgroundColor: Colors.white,
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name der Kategorie'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.insert_emoticon),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        Navigator.of(context).pop();
                      })
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    saveButton(CountButton button) {
      widget.repo.save(CountButtonObj(
          button.name, button.message, button.icon, button.color.value));
    }

    createNewButton(String name) {
      CountButton button = CountButton(
        name: name,
        message: 'Weiter so!',
        icon: "directions_run",
        color: Colors.limeAccent[400],
      );
      saveButton(button);
      setState(() {
        log('added new button ${button.name}');
        widget.buttons.add(button);
        log('list length ${widget.buttons.length}');
      });
    }

    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.orange, title: Text('Alltagszähler')),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => createDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: widget.buttons.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(child: widget.buttons[index]);
          },
        ),
      ),
    );
  }
}

class CountButton extends StatefulWidget {
  CountButton({
    Key key,
    @required this.name,
    @required this.message,
    @required this.icon,
    @required this.color,
  }) : super(key: key);

  final String name;
  final String message;
  final String icon;
  final Color color;

  static CountButton fromJson(Map<String, dynamic> json) {
    return CountButton(
      name: json['name'],
      message: json['message'],
      icon: json['icon'],
      color: Color(json['color']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'message': message,
        'icon': icon,
        'color': color.value,
      };

  @override
  _CountButtonState createState() => _CountButtonState();
}

class _CountButtonState extends State<CountButton> {
  void _incrementCounter(CounterState counterState) {
    counterState.increment();
    final snackBar = SnackBar(
      duration: Duration(
        seconds: 1,
      ),
      content: Text(widget.message),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final counterState = Provider.of<CounterState>(context);

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: FlatButton(
        color: widget.color,
        child: Padding(
          padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
          child: Row(
            children: <Widget>[
              Icon(MdiIcons.fromString(widget.icon)),
              Text('        ${widget.name}        '),
              Text('${counterState.value}        '),
            ],
          ),
        ),
        onPressed: () => _incrementCounter(counterState),
      ),
    );
  }
}
