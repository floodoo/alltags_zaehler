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
  List<Kategorie> kategorien = [];

  //new
  final String name = 'floodoo.db';
  final String kategorieDB = 'altagszaehler_kategorie';
  final String zaehlerDB = 'altagszaehler_zaehler';

  bool _isLoading = false;
  Database _database;

  bool get isLoading => _isLoading;

  void _initDatabase() async {
    _isLoading = true;
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
    kategorien = katList;
    notifyListeners();
  }

  getZaehlerCounts() async {
    for (Kategorie kat in kategorien) {
      zaehler[kat.name] = await getZaehlerCountForKategorie(kat);
      notifyListeners();
    }
  }

  Future<int> getZaehlerCountForKategorie(Kategorie kategorie) async {
    num katId = getKategorieId(kategorie.name);

    List<Map<String, dynamic>> list =
        await _database.rawQuery('SELECT count(*) FROM $zaehlerDB WHERE kategorie = $katId');
    print("thats the COUNT ${list}");
    return list[0]['count(*)'];
  }
}
