import 'package:flutter/material.dart';

class ThemeChanger extends ChangeNotifier {
  ThemeData currentTheme = ThemeData.light();

  void toggleTheme({required ThemeData selectedTheme}) {
    currentTheme = selectedTheme;
    notifyListeners();
  }
}
