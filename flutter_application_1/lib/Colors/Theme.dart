import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData green = ThemeData(
    primarySwatch: Colors.green, scaffoldBackgroundColor: Colors.green.shade50);

ThemeData red = ThemeData(
    primarySwatch: Colors.red, scaffoldBackgroundColor: Colors.red.shade50);

class ThemeColorData with ChangeNotifier {
  static SharedPreferences? _sharedPrefObject;
  bool _isGreen = true;

  bool get isGreen => _isGreen;

  ThemeData get themeColor {
    return isGreen ? green : red;
  }

  void toggleTheme() {
    _isGreen = !_isGreen;
    saveThemeToSharePref(_isGreen);
    notifyListeners();
  }

  Future<void> createSharedPrefObject() async {
    //asenkron bir yapıda uzun zaman alan veya farklı görevdeki işlemler aynı anda gerçekleştirilir.
    _sharedPrefObject = await SharedPreferences.getInstance();
    //await asenkron olarka calıstır ve fonksiiyon bittiği zaman bir sonrakkine devam et
  }

  void saveThemeToSharePref(bool value) {
    _sharedPrefObject!.setBool('themeData', value);
  }

  void loadThemeFromSharePref() async {
    // await createSharedPrefObject();
    _isGreen = _sharedPrefObject!.getBool('themeData') ?? true;

    /*  if (_sharedPrefObject!.getBool('themeData') == null) {
      _isGreen = true;
    } else {
      _isGreen != _sharedPrefObject!.getBool('themeData');
    }*/
    // _isGreen != _sharedPrefObject?.getBool('themeData');
  }
}
