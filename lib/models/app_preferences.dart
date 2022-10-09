import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData lightThemeValues = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  accentColor: Colors.red,
  scaffoldBackgroundColor: Colors.grey[100],
);
ThemeData darkThemeValues = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  // ignore: deprecated_member_use
  accentColor: Colors.red,
  scaffoldBackgroundColor: Colors.black87,
);

class AppPreferences with ChangeNotifier {
  bool _darkTheme = false;
  bool _deleteConfirm = false;
  SharedPreferences? _preferences;

  bool get darkTheme => _darkTheme;
  bool get deleteConfirm => _deleteConfirm;

  AppPreferences() {
    _loadSettingsFromPreference();
  }

  _initializePreference() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  _loadSettingsFromPreference() async {
    await _initializePreference();

    _darkTheme = _preferences?.getBool('darkTheme') ?? false;
    _deleteConfirm = _preferences?.getBool('deleteConfirm') ?? true;
    notifyListeners();
  }

  void toggleOption(String optionName, bool newValue) {
    if (optionName == 'darkTheme') {
      _darkTheme = newValue;
    }
    if (optionName == 'deleteConfirm') {
      _deleteConfirm = newValue;
    }

    _saveSettingsOptionToPreference(optionName, newValue);
    notifyListeners();
  }

  _saveSettingsOptionToPreference(String optionName, bool newValue) async {
    await _initializePreference();
    _preferences?.setBool(optionName, newValue);
  }

//get option value
  bool? getOptionValue(String optionName) {
    final result = _preferences?.getBool(optionName);
    if (result == null) {
      _preferences?.setBool(optionName, true);
    }
    return result ?? _preferences?.getBool(optionName);
  }
}
