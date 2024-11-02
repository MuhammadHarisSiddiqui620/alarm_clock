import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isLightTheme = false;

  bool get isLightTheme => _isLightTheme;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isLightTheme = prefs.getBool('selected_theme') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme(bool isLight) async {
    _isLightTheme = isLight;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('selected_theme', _isLightTheme);
    notifyListeners();
  }
}
