import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SaveSql with ChangeNotifier {
  SaveSql() {
    _init();
  }

  static String path = 'floodoo.db';

  bool _isLoading = false;
  Database _database;

  bool get isLoading => _isLoading;

  _init() async {
    _isLoading = true;
    notifyListeners();
    _database = await openDatabase(path);

    await _database.execute(''' 
      CREATE TABLE IF NOT EXISTS kategorie (
        id INTEGER PRIMARY KEY, 
        name TEXT, 
        snackbar TEXT,
        farbe INTEGER,
        icon TEXT) 
      ''');

    await _database.execute(''' 
      CREATE TABLE IF NOT EXISTS zaehler (
        id INTEGER PRIMARY KEY, 
        zahl INTEGER,
        zeitstempel INTEGER,
        kategorie INTEGER,
        FOREIGN KEY(kategorie) REFERENCES kategorie(id)
        ) 
      ''');

    List<Map> tables =
        await _database.rawQuery('SELECT name FROM sqlite_master ');

    print("<<<<<<< hier eine table liste >>>>>>>>");
    print(tables.toString());

    // Insert some records in a transaction

    await _database.insert('kategorie', {
      'name': 'Kaffee',
      'snackbar': 'Sauf nicht so viel',
      'farbe': 234258345,
      'icon': 'kaffee'
    });

    List<Map> katList = await _database.rawQuery('SELECT * FROM kategorie');

    print("KATEGORIE: ${katList.toString()}");

    await _database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO kategorie(name, snackbar, farbe, icon) VALUES("Bier", "Hier ist dein Bier", 283239842934, "Beeer")');
      print('inserted1: $id1');
      int id11 = await txn.rawInsert(
          'INSERT INTO kategorie(name, snackbar, farbe, icon) VALUES("Zigarette", "Hier ist deine Zigarre", 283239842934, "Zigs")');
      print('inserted1: $id11');
      int id2 = await txn.rawInsert(
          'INSERT INTO zaehler(zahl, zeitstempel, kategorie) VALUES(17, 9873482347, 1)',
          ['another name', 12345678, 3.1416]);
      print('inserted2: $id2');
    });

    katList = await _database.rawQuery('SELECT * FROM kategorie');
    List<Map> zaeList = await _database.rawQuery('SELECT * FROM zaehler');

    print("KATEGORIE: ${katList.toString()}");
    print("ZAEHER: ${zaeList.toString()}");

    _isLoading = false;
    notifyListeners();
  }
}
