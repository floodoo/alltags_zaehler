import 'package:alltags_zaehler/speichern.dart';
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
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyCounter> {
  @override
  Widget build(BuildContext context) {
    //final counterState = Provider.of<CounterState>(context);

    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.orange, title: Text('Alltagszähler')),
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            children: <Widget>[
              CountButton(
                name: 'Bier',
                message: 'Du hast wieder Bier getrunken',
                icon: Icon(Icons.local_drink),
                color: Colors.white,
              ),
              CountButton(
                name: 'Zigarette',
                message: 'Du warst wieder Rauchen',
                icon: Icon(Icons.smoking_rooms),
                color: Colors.white,
              ),
              CountButton(
                  name: 'Kaffee',
                  message: 'Du trinkst schon wieder Kaffee?!',
                  icon: Icon(Icons.local_cafe),
                  color: Colors.white),
              CountButton(
                name: 'Handy',
                message: 'Du bist schon wieder am Handy?!',
                icon: Icon(Icons.smartphone),
                color: Colors.white,
              ),
              CountButton(
                name: 'Sport',
                message: 'Weiter so',
                icon: Icon(Icons.directions_run),
                color: Colors.white,
              ),
            ],
          );
        },
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
  final Icon icon;
  final Color color;

  @override
  _CountButtonState createState() => _CountButtonState();
}

class _CountButtonState extends State<CountButton> {
  @override
  void initState() {
    super.initState();
    //widget.counter = CounterState(widget.name);
    waitCounter();
  }

  void waitCounter() async {
    //await widget.counter.load();
    setState(() {});
  }

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
              widget.icon,
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
