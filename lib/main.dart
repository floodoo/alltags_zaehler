import 'package:flutter/material.dart';

void main()=> runApp(MyApp());

class MyApp extends StatelessWidget {
  @override


  Widget build(BuildContext context) {
    return MaterialApp(
      title :'Alltagszähler',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text('Alltagszähler')
        ),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            
            children: <Widget>[
              RaisedButton(
                child: Row(
                  children: <Widget>[
                    Text('Zigaretten'),Icon(Icons.smoke_free), 
                  ],
                ),
                onPressed: () {
                  final snackBar = SnackBar(
                    content: Text('Du hast eine Zigarette mehr geraucht'),
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                },
              ), 
            ],
          );
        },
      ),
      
      ),
    );

  }
}