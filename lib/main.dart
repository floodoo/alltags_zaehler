import 'package:alltags_zaehler/model/kategorie.dart';
import 'package:alltags_zaehler/model/zaehler.dart';
import 'package:alltags_zaehler/save_sql.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alltagszähler',
      home: ChangeNotifierProvider(
        create: (context) => SaveSql(),
        child: MyCounter(),
      ),
    );
  }
}

class MyCounter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final saveSql = Provider.of<SaveSql>(context);

    saveButton(CountButton button) {
      Kategorie kat = Kategorie(
        name: button.name,
        snackbar: button.message,
        farbe: button.color.value,
        icon: button.icon,
      );
      saveSql.saveKategorie(kat);
    }

    void createNewButton(String name, String snackbar, String icon) {
      CountButton button = CountButton(
        name: name,
        message: snackbar,
        icon: icon,
        color: Colors.limeAccent[400],
        value: 1,
      );

      saveButton(button);
    }

    void createDialog(BuildContext context) {
      final _kategoriecontroller = TextEditingController();
      final _snackbarcontroller = TextEditingController();
      final _iconcontroller = TextEditingController();
      _launchURL() async {
        const url = 'https://ionicons.com/';
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      }

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
                  child: Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Name der Kategorie'),
                        controller: _kategoriecontroller,
                      ),
                      TextField(
                        decoration: InputDecoration(border: OutlineInputBorder(), labelText: 'Nachricht'),
                        controller: _snackbarcontroller,
                      ),
                      TextField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder(), labelText: 'Die Icons hier rein schreiben'),
                        controller: _iconcontroller,
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.insert_emoticon),
                      onPressed: _launchURL,
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
                          createNewButton(
                              _kategoriecontroller.text.trim(), _snackbarcontroller.text, _iconcontroller.text);
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
            onPressed: () => _explode(context),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: saveSql.curIndex,
        onTap: saveSql.onChangePage,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.accessibility_new),
            title: new Text('Flo'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.poll),
            title: new Text('Grafik'),
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () => createDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
      body: saveSql.curIndex == 0
          ? Container(
              child: Center(
                child: Text("hey, i'm Flo."),
              ),
            )
          : saveSql.curIndex == 1
              ? Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: saveSql.kategorien.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        child: CountButton(
                          name: saveSql.kategorien[index].name,
                          message: saveSql.kategorien[index].snackbar,
                          icon: saveSql.kategorien[index].icon,
                          color: Color(saveSql.kategorien[index].farbe),
                          value: saveSql.zaehler[saveSql.kategorien[index].name] == null
                              ? 0
                              : saveSql.zaehler[saveSql.kategorien[index].name],
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  child: Center(
                    child: Text('Grafik'),
                  ),
                ),
    );
  }

  _explode(BuildContext context) {
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

  @override
  _CountButtonState createState() => _CountButtonState();
}

class _CountButtonState extends State<CountButton> {
  void _incrementCounter(SaveSql saveSql) {
    saveSql.saveZeahler(
      Zaehler(
        kategorie: saveSql.getKategorieId(widget.name),
        zahl: widget.value == null ? 1 : widget.value + 1,
        zeitstempel: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    saveSql.getZaehlerCounts();

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
    final saveSql = Provider.of<SaveSql>(context);

    Widget _morePopup() => PopupMenuButton<int>(
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 1,
              child: Text("Löschen"),
            ),
            PopupMenuItem(
              value: 2,
              child: Text("Zurücksetzen"),
            ),
          ],
          onSelected: (value) {
            switch (value) {
              case 1:
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Willst du es wirklich Löschen?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Abbrechen'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Bestätigen'),
                            onPressed: () {
                              saveSql.deleteKategorie(widget.name);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
                break;
              case 2:
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Willst du es wirklich Zurücksetzen?'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Abbrechen'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text('Bestätigen'),
                            onPressed: () {
                              saveSql.resetKategorie(widget.name);
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    });
                break;
              default:
                print('default');
            }
          },
          icon: Icon(Icons.more_vert),
        );

    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
      child: FlatButton(
        color: widget.color,
        child: Padding(
          padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
          child: Row(
            children: <Widget>[
              Icon(MdiIcons.fromString(widget.icon)),
              Expanded(
                child: Center(child: Text('${widget.name}')),
              ),
              Text('${widget.value}'),
              SizedBox(width: 25),
              _morePopup(),
            ],
          ),
        ),
        onPressed: () => _incrementCounter(saveSql),
      ),
    );
  }
}
