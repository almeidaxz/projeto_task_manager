import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeMode = ThemeData.light();

  ThemeData get themeMode => _themeMode;

  set themeMode(ThemeData themeMode) {
    _themeMode = themeMode;
  }

  void toggleTheme() {
    if (_themeMode == ThemeData.light()) {
      _themeMode = ThemeData.dark();
    } else {
      _themeMode = ThemeData.light();
    }
    notifyListeners();
  }
}
