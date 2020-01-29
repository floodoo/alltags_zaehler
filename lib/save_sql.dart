import 'package:alltags_zaehler/model/kategorie.dart';
import 'package:alltags_zaehler/model/zaehler.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SaveSql with ChangeNotifier {
  SaveSql() {
    _initDatabase();
  }

  //name anzahl
  final Map<String, int> zaehler = {};

  //Kategorien
  final List<Kategorie> kategorien = [];

  //Zaehler einer Kategorie
  List<Zaehler> zaehlerOfKategorie = [];
  List<Zaehler> zaehlerStats = [];

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
        zeitstempel INTEGER,
        kategorie INTEGER,
        FOREIGN KEY(kategorie) REFERENCES kategorie(id)
        ); 
      ''');
    await loadKategories();
    await getZaehlerCounts();

    await getZaehlerByKategorie("Sport");
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
    notifyListeners();
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
          zeitstempel:
              DateTime.fromMicrosecondsSinceEpoch(maps[i]['zeitstempel']),
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
          zeitstempel:
              DateTime.fromMicrosecondsSinceEpoch(maps[i]['zeitstempel']),
          kategorie: maps[i]['kategorie']);
    });

    _loadZaehler = false;
    notifyListeners();
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
