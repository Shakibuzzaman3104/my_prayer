import 'package:flutter/material.dart';
import 'package:my_prayer/local_database/sharedpreferences.dart';
import 'package:my_prayer/utils/themeData.dart';

class ThemeViewModel with ChangeNotifier {
  ThemeData _themeData;
  MySharedPreferences sharedPreferences;

  bool _isDark = false;

  getIsDark() async {
    _isDark = await sharedPreferences.getIsDark();
    notifyListeners();
  }

  bool get theme => _isDark;

  ThemeViewModel(this._themeData) {
    sharedPreferences = MySharedPreferences.getInstance();
  }

  getTheme() => _themeData;

  setTheme(bool val) async {
    if (val)
      _themeData = darkTheme;
    else
      _themeData = lightTheme;
    _isDark=val;
    await sharedPreferences.setIsDark(val);
    notifyListeners();
  }
}
