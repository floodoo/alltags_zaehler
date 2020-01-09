import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alltagszähler',
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.orange, title: Text('Alltagszähler')),
        body: Builder(
          builder: (BuildContext context) {
            return Column(
              children: <Widget>[
                CountButton(
                  name: 'Bier',
                  message: 'Du hast wieder Bier getrunken',
                  icon: Icon(Icons.local_bar),
                  color: Colors.limeAccent[400],
                ),
                CountButton(
                  name: 'Zigarette',
                  message: 'Du warst wieder Rauchen',
                  icon: Icon(Icons.smoking_rooms),
                  color: Colors.limeAccent[400],
                ),
                CountButton(
                    name: 'Kaffee',
                    message: 'Du trinkst schon wieder Kaffee?!',
                    icon: Icon(Icons.local_cafe),
                    color: Colors.limeAccent[400]),
                CountButton(
                  name: 'Wie oft warst du am Handy',
                  message: 'Du bist schon wieder am Handy?!',
                  icon: Icon(Icons.smartphone),
                  color: Colors.limeAccent[400],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class CountButton extends StatefulWidget {
  const CountButton({
    Key key,
    @required this.name,
    @required this.message,
    @required this.icon,
    @required this.color,
  }) : super(key: key);

  final String name;
  final String message;
  final Icon icon;
  final Color color;

  @override
  _CountButtonState createState() => _CountButtonState();
}

class _CountButtonState extends State<CountButton> {
  int _counter = 0;

  void _incrementCounter(BuildContext context) {
    setState(() {
      _counter++;
    });

    final snackBar = SnackBar(
      content: Text(widget.message),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: FlatButton(
        color: Colors.limeAccent[400],
        child: Padding(
          padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
          child: Row(
            children: <Widget>[
              widget.icon,
              Text('        ${widget.name}        '),
              Text('$_counter        '),
            ],
          ),
        ),
        onPressed: () => _incrementCounter(context),
      ),
    );
  }
}
