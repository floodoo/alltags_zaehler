import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class SaveSql with ChangeNotifier {
  SaveSql() {
    _init();
  }

  static String path = 'assets/floodoo.db';

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
        zeitstempel INTEGER) 
      ''');

    _isLoading = false;
    notifyListeners();
  }
}
