import 'package:shared_preferences/shared_preferences.dart';

class CounterState {
  CounterState(String sharedPrefsKey) {
    this._sharedPrefsKey = sharedPrefsKey;
    //_load();
  }

  String _sharedPrefsKey;

  int _value;

  int get value => _value;

  bool _isWaiting = true;
  bool _hasError = false;

  bool get isWaiting => _isWaiting;
  bool get hasError => _hasError;

  void increment() => _setValue(_value + 1);
  void reset() => _setValue(0);

  void _setValue(int newValue) {
    _value = newValue;
    _save();
  }

  Future<bool> load() async {
    return await _store(load: true);
  }

  void _save() => _store();

  Future<bool> _store({bool load = false}) async {
    _hasError = false;
    _isWaiting = true;

    await Future.delayed(Duration(milliseconds: 500));

    try {
      final prefs = await SharedPreferences.getInstance();
      if (load) {
        _value = prefs.getInt(_sharedPrefsKey) ?? 0;
      } else {
        await prefs.setInt(_sharedPrefsKey, _value);
      }
      _hasError = false;
      return false;
    } catch (error) {
      _hasError = true;
      return false;
    }
    _isWaiting = false;
    return true;
  }
}
