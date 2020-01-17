import 'package:alltags_zaehler/main.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterState with ChangeNotifier {
  CounterState() {
    _load();
  }

  static const _sharedPrefsKey = 'counterState';

  int _value;

  List<CountButton> buttons = [];

  int get value => _value;

  bool _isWaiting = true;
  bool _hasError = false;

  bool get isWaiting => _isWaiting;
  bool get hasError => _hasError;

  void increment() => _setValue(value + 1);
  void reset() => _setValue(0);

  void _setValue(int newValue) {
    _value = newValue;
    _save();
  }

  void _load() => _store(load: true);
  void _save() => _store();

  void _store({bool load = false}) async {
    _hasError = false;
    _isWaiting = true;
    notifyListeners();

    await Future.delayed(Duration(milliseconds: 500));

    try {
      final prefs = await SharedPreferences.getInstance();
      if (load) {
        _value = prefs.getInt(_sharedPrefsKey) ?? 0;
      } else {
        await prefs.setInt(_sharedPrefsKey, _value);
      }
      _hasError = false;
    } catch (error) {
      _hasError = true;
    }
    _isWaiting = false;
    notifyListeners();
  }
}
