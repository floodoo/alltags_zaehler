import 'package:alltags_zaehler/model/zaehler.dart';
import 'package:alltags_zaehler/save_sql.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

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
        zeitstempel: DateTime.now(),
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
