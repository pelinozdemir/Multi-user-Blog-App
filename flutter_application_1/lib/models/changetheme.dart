import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorThemeData with ChangeNotifier {
  final ThemeData _darkTheme = ThemeData(
      primaryColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
      primarySwatch: Colors.grey,
      primaryIconTheme: IconThemeData(color: Colors.white),
      scaffoldBackgroundColor: Color.fromARGB(213, 2, 19, 35),
      appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          color: Color.fromARGB(213, 2, 19, 35),
          actionsIconTheme: IconThemeData(color: Colors.white)),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      backgroundColor: Color.fromARGB(213, 2, 19, 35),
      primaryColorDark: Color.fromARGB(255, 22, 22, 22),
      cardColor: Colors.white38,
      canvasColor: Colors.white,
      dividerColor: Colors.white60,
      // bottomAppBarTheme: BottomAppBarTheme(color: ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(213, 2, 19, 35),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedIconTheme: IconThemeData(color: Colors.white),
          unselectedIconTheme: IconThemeData(color: Colors.white54)),
      textTheme: TextTheme(
          subtitle1: TextStyle(color: Colors.white),
          headline3: TextStyle(color: Colors.white)));
  final ThemeData _lightTheme = ThemeData(
      primaryColor: Colors.white60,
      primarySwatch: Colors.grey,
      scaffoldBackgroundColor: Colors.white60,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      backgroundColor: Colors.white60,
      primaryColorDark: Colors.white60,
      cardColor: Color.fromARGB(213, 2, 19, 35),
      canvasColor: Color.fromARGB(213, 2, 19, 35),
      dividerColor: Colors.white60,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromARGB(210, 255, 230, 177),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedIconTheme: IconThemeData(color: Colors.white),
          unselectedIconTheme: IconThemeData(color: Colors.white54)),
      appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          actionsIconTheme: IconThemeData(color: Colors.white)),
      textTheme: TextTheme(
          subtitle1: TextStyle(color: Colors.black),
          headline3: TextStyle(color: Colors.black)));

  static SharedPreferences? _sharedPref;
  bool _isDark = false;

  void switchTheme(bool selected) {
    _isDark = selected;
    saveThemeToSharedPref(selected);
    notifyListeners();
  }

  ThemeData get selectedThemeData => _isDark ? _darkTheme : _lightTheme;
  bool get isLight => _isDark;

  /// Shared Preferences Methods
  Future<void> createPrefObject() async {
    _sharedPref = await SharedPreferences.getInstance();
  }

  void saveThemeToSharedPref(bool value) {
    _sharedPref!.setBool('themeData', value);
  }

  void loadThemeFromSharedPref() {
    print('loadTheme.. fonksiyonu çalıştı');
    _isDark = _sharedPref!.getBool('themeData') == true;
  }
}
