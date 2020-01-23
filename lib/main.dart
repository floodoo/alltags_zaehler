import 'dart:developer';

import 'package:alltags_zaehler/countButton.obj.dart';
import 'package:alltags_zaehler/save_sql.dart';
import 'package:alltags_zaehler/speichern.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pref_dessert/pref_dessert_internal.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SaveSql();
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
      value: 2,
    ),
    CountButton(
      name: 'Zigarette',
      message: 'Du warst wieder Rauchen?!',
      icon: "smoking",
      color: Colors.limeAccent[400],
      value: 2,
    ),
    CountButton(
      name: 'Kaffee',
      message: 'Du trinkst schon wieder Kaffee?!',
      icon: "coffee",
      color: Colors.limeAccent[400],
      value: 3,
    ),
    CountButton(
      name: 'Sport',
      message: 'Weiter so!',
      icon: "run",
      color: Colors.limeAccent[400],
      value: 3,
    ),
  ];

  final repo = new FuturePreferencesRepository<CountButtonObj>(new CountButtonDesSer());

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
        value: countbuttonobject.value,
      );

      widget.buttons.add(button);
    }
  }

  @override
  Widget build(BuildContext context) {
    saveButton(CountButton button) {
      widget.repo.save(CountButtonObj(button.name, button.message, button.icon, button.color.value, button.value));
    }

    void createNewButton(String name) {
      CountButton button = CountButton(
        name: name,
        message: 'Weiter so!',
        icon: "directions_run",
        color: Colors.limeAccent[400],
        value: 1,
      );

      saveButton(button);
      setState(() {
        log('added new button ${button.name}');
        widget.buttons.add(button);
        log('list length ${widget.buttons.length}');
      });
    }

    void createDialog(BuildContext context) {
      final _controller = TextEditingController();
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
                    decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Name der Kategorie'),
                    controller: _controller,
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
                          createNewButton(_controller.text);
                          Navigator.of(context).pop();
                        })
                  ],
                )
              ],
            );
          });
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('Alltagszähler'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.star,
                color: Colors.orange,
              ),
              onPressed: () => _exlpode(),
            ),
          ],
        ),
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
        ));
  }

  _exlpode() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewPage()));
  }
}

class NewPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return GestureDetector(
        onDoubleTap: () => Navigator.pop(context),
        child: Stack(children: <Widget>[
          Positioned(
              top: 100,
              left: 10,
              height: 200,
              width: 500,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_red.flr",
                animation: "explode",
              ))),
          Positioned(
              top: 500,
              left: 10,
              height: 150,
              width: 200,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_blue.flr",
                animation: "explode",
              ))),
          Positioned(
              top: 300,
              left: 10,
              height: 150,
              width: 300,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_green.flr",
                animation: "explode",
              ))),
          Positioned(
              top: 100,
              left: 10,
              height: 150,
              width: 200,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_pink.flr",
                animation: "explode",
              ))),
          Positioned(
              top: 600,
              left: 50,
              height: 150,
              width: 300,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_yellow.flr",
                animation: "explode",
              ))),
          Positioned(
              top: 450,
              left: 10,
              height: 150,
              width: 600,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_pink.flr",
                animation: "explode",
              ))),
          Positioned(
              top: 600,
              left: 10,
              height: 150,
              width: 600,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_red.flr",
                animation: "explode",
              ))),
          Positioned(
              top: 300,
              left: 100,
              height: 200,
              width: 300,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_yellow.flr",
                animation: "explode",
              ))),
          Positioned(
              top: 50,
              left: 200,
              height: 150,
              width: 300,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_blue.flr",
                animation: "explode",
              ))),
          Positioned(
              top: 400,
              left: 1,
              height: 150,
              width: 300,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_red.flr",
                animation: "explode",
              ))),
          Positioned(
              top: 200,
              left: 1,
              height: 150,
              width: 300,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_red1.flr",
                animation: "explode",
              ))),
          Positioned(
              top: 100,
              left: 1,
              height: 150,
              width: 300,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_blue1.flr",
                animation: "explode",
              ))),
          Positioned(
              top: 500,
              left: 1,
              height: 150,
              width: 500,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_blue1.flr",
                animation: "explode",
              ))),
          Positioned(
              top: 150,
              left: 1,
              height: 150,
              width: 600,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_yellow1.flr",
                animation: "explode",
              ))),
          Positioned(
              top: 500,
              left: 1,
              height: 150,
              width: 600,
              child: Container(
                  child: FlareActor(
                "assets/animation/firework_pink1.flr",
                animation: "explode",
              ))),
        ]));
  }

  static void startFlare(FlareActor flare) {}
}

class CountButton extends StatefulWidget {
  CountButton({
    Key key,
    @required this.name,
    @required this.message,
    @required this.icon,
    @required this.color,
    @required this.value,
  }) : super(key: key);

  final String name;
  final String message;
  final String icon;
  final Color color;
  final num value;

  static CountButton fromJson(Map<String, dynamic> json) {
    return CountButton(
      name: json['name'],
      message: json['message'],
      icon: json['icon'],
      color: Color(json['color']),
      value: json['value'],
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
