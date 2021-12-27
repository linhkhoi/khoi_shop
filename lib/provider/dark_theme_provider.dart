

import 'package:flutter/material.dart';
import 'package:khoi_shop/models/dark_theme_preferences.dart';

class DarkThemeProvider extends ChangeNotifier{

  DarkThemePreferences darkThemePreferences = DarkThemePreferences();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreferences.setDarkTheme(value);
    notifyListeners();
  }
}