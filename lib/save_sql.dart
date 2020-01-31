import 'package:alltags_zaehler/model/kategorie.dart';
import 'package:alltags_zaehler/model/zaehler.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import 'model/chart_model.dart';

class SaveSql with ChangeNotifier {
  SaveSql() {
    _initDatabase();
  }

  Color _pickerColor = Color(0xff443a49);
  Color _currentColor = Color(4278604287);

  Color get pickerColor => _pickerColor;
  Color get currentColor => _currentColor;

  //name anzahl
  final Map<String, int> zaehler = {};

  //Kategorien
  final List<Kategorie> kategorien = [];

  //Zaehler einer Kategorie
  List<Zaehler> zaehlerOfKategorie = [];
  List<Zaehler> zaehlerStats = [];

  //syncfusion chart
  final List<charts.Series<ChartDataModel, String>> chartBars = [];
  final Map<num, Map<String, num>> chartData = {};

  bool _loadZaehler = false;
  bool get loadZaehler => _loadZaehler;

  //new
  final String name = 'floodoo.db';
  final String kategorieDB = 'altagszaehler_kategorie';
  final String zaehlerDB = 'altagszaehler_zaehler';

  bool _isLoading = false;
  Database _database;

  bool get isLoading => _isLoading;

  //keeps also state for page nav
  int _curIndex = 1;
  int get curIndex => _curIndex;

  void changeColor(Color color) {
    _pickerColor = color;
    notifyListeners();
  }

  void setCurrentColor() {
    _currentColor = _pickerColor;
    notifyListeners();
  }

  onChangePage(int index) {
    _curIndex = index;
    notifyListeners();
    switch (_curIndex) {
      case 0:
        // contents = "Home";
        break;
      case 1:
        // contents = "Articles";
        break;
      case 2:
        // contents = "User";
        break;
    }
  }

  void _initDatabase() async {
    _isLoading = true;
    print('PATH ${await getDatabasesPath()}');
    _database = await openDatabase(
      join(await getDatabasesPath(), name),
      version: 3,
    );
    // print('delete all');
    // await _database.execute('''
    //   DROP TABLE $kategorieDB;
    //   ''');

    print('create kategorie');
    await _database.execute(''' 
      CREATE TABLE IF NOT EXISTS $kategorieDB (
        id INTEGER PRIMARY KEY, 
        name TEXT UNIQUE, 
        snackbar TEXT,
        farbe INTEGER,
        icon TEXT);
      ''');
    print('create Zaehler');
    await _database.execute(''' 
      CREATE TABLE IF NOT EXISTS $zaehlerDB (
        id INTEGER PRIMARY KEY, 
        zahl INTEGER,
        zeitstempel TEXT,
        kategorie INTEGER,
        FOREIGN KEY(kategorie) REFERENCES kategorie(id)
        ); 
      ''');
    await loadKategories();
    await getZaehlerCounts();
    notifyListeners();
    _isLoading = false;
  }

  saveKategorie(Kategorie kategorie) async {
    print("save Kategorie ${kategorie.name}");
    await _database.insert(
      kategorieDB,
      kategorie.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    loadKategories();
    notifyListeners();
  }

  saveZeahler(Zaehler zaehler) async {
    print("save zahler ${zaehler.zahl} in $zaehlerDB");
    await _database.insert(
      zaehlerDB,
      zaehler.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await getZaehler();
  }

  int getKategorieId(String name) {
    Iterable<Kategorie> list = kategorien.where((f) => f.name == name);
    return list.toList()[0].id;
  }

  Future<void> loadKategories() async {
    final List<Map<String, dynamic>> maps = await _database.query(kategorieDB);

    List<Kategorie> katList = List.generate(maps.length, (i) {
      return Kategorie(
        id: maps[i]['id'],
        name: maps[i]['name'],
        snackbar: maps[i]['snackbar'],
        farbe: maps[i]['farbe'],
        icon: maps[i]['icon'],
      );
    });
    kategorien.clear();
    kategorien.addAll(katList);
    createBarSeries();
    notifyListeners();
  }

  // BARS
  createBarSeries() {
    chartBars.clear();
    for (Kategorie kategorie in kategorien) {
      List<ChartDataModel> list = getDataForChart(kategorie.id);
      print('${kategorie.name}: x: ${list[0].x}, y:${list[0].y}');
      chartBars.add(
        new charts.Series<ChartDataModel, String>(
          id: kategorie.name,
          colorFn: (ChartDataModel model, _) =>
              charts.ColorUtil.fromDartColor(Color(kategorie.farbe)),
          domainFn: (ChartDataModel model, _) => model.x,
          measureFn: (ChartDataModel model, _) => model.y,
          data: list, //das müsste nach kategorie aufgeteilt werden
        ),
      );
    }
  }

  getZaehlerByKategorie(String name) async {
    _loadZaehler = true;
    int katId = getKategorieId(name);
    final List<Map<String, dynamic>> maps = await _database
        .query("SELECT * FROM $zaehlerDB WHERE kategorie = $katId;");

    zaehlerOfKategorie = List.generate(maps.length, (i) {
      return Zaehler(
          id: maps[i]['id'],
          zahl: maps[i]['zahl'],
          zeitstempel: DateTime(maps[i]['zeitstempel']),
          kategorie: maps[i]['kategorie']);
    });

    _loadZaehler = false;
    notifyListeners();
  }

  getZaehler() async {
    _loadZaehler = true;
    final List<Map<String, dynamic>> maps = await _database.query(zaehlerDB);

    zaehlerStats = List.generate(maps.length, (i) {
      return Zaehler(
          id: maps[i]['id'],
          zahl: maps[i]['zahl'],
          zeitstempel: DateTime.parse(maps[i]['zeitstempel']), //ERROR
          kategorie: maps[i]['kategorie']);
    });

    _loadZaehler = false;
    createChartData();
    createBarSeries();
    notifyListeners();
  }

  //Data of chart
  createChartData() {
    chartData.clear();
    for (Zaehler zaehler in zaehlerStats) {
      print(
          'here we go: ${zaehler.zeitstempel.toIso8601String().substring(0, 9)}');

      if (chartData[zaehler.kategorie] == null) {
        chartData[zaehler.kategorie] = {};
      }
      if (chartData[zaehler.kategorie]
              [zaehler.zeitstempel.toIso8601String().substring(0, 9)] ==
          null) {
        chartData[zaehler.kategorie]
            [zaehler.zeitstempel.toIso8601String().substring(0, 9)] = 0;
      }

      chartData[zaehler.kategorie]
          [zaehler.zeitstempel.toIso8601String().substring(0, 9)]++;

      // ChartDataModel model = chartData[zaehler.kategorie];
      // model.x = '${zaehler.zeitstempel.day}.${zaehler.zeitstempel.month}.${zaehler.zeitstempel.year}';
      // print(model.x);

      // if (chartData[zaehler.zeitstempel.toIso8601String().substring(0, 9)] == null) {
      //   chartData[zaehler.zeitstempel.toIso8601String().substring(0, 9)] = ChartDataModel();
      // }
      // ChartDataModel model = chartData[zaehler.zeitstempel.toIso8601String().substring(0, 9)];
      // model.x = '${zaehler.zeitstempel.day}.${zaehler.zeitstempel.month}.${zaehler.zeitstempel.year}';
      // if (model.y[zaehler.kategorie] == null) {
      //   model.y[zaehler.kategorie] = 0;
      // }
      // model.y[zaehler.kategorie] = model.y[zaehler.kategorie] + 1;
    }
    notifyListeners();
    print(chartData);
  }

  List<ChartDataModel> getDataForChart(num kategorie) {
    if (chartData[kategorie] == null) return [];

    List<ChartDataModel> list = [];

    for (String date in chartData[kategorie].keys.toList()) {
      ChartDataModel model = ChartDataModel();
      model.x = date;
      model.y = chartData[kategorie][date];
      list.add(model);
    }
    return list;
  }

  getZaehlerCounts() async {
    zaehler.clear();
    for (Kategorie kat in kategorien) {
      zaehler[kat.name] = await getZaehlerCountForKategorie(kat);
    }
    notifyListeners();
  }

  Future<int> getZaehlerCountForKategorie(Kategorie kategorie) async {
    num katId = getKategorieId(kategorie.name);

    List<Map<String, dynamic>> list = await _database
        .rawQuery('SELECT count(*) FROM $zaehlerDB WHERE kategorie = $katId;');
    return list[0]['count(*)'];
  }

  deleteKategorie(String name) async {
    resetKategorie(name);
    int id = getKategorieId(name);
    await _database.rawDelete('DELETE FROM $kategorieDB WHERE id = $id;');
    loadKategories();
  }

  resetKategorie(String name) async {
    int id = getKategorieId(name);
    await _database.delete(zaehlerDB, where: "kategorie = ?", whereArgs: [id]);
    getZaehlerCounts();
  }
}
