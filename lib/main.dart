import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _counter = 0;

  void _incrementCounter(BuildContext context) {
    setState(() {
      _counter++;
    });
    final snackBar = SnackBar(
      content: Text('Du hast eine Zigarette mehr geraucht'),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

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
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.smoking_rooms),
                      Text('        Zigaretten        '),
                      Text('$_counter        ')
                    ],
                  ),
                  onPressed: () => _incrementCounter(context),
                ),
              ],
            );
          },
        ),
        body: Builder(
          builder: (BuildContext context) {
            return Column(
              children: <Widget>[
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.smoking_rooms),
                      Text('        Zigaretten        '),
                      Text('$_counter        ')
                    ],
                  ),
                  onPressed: () => _incrementCounter(context),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
