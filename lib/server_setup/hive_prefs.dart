import 'package:hive/hive.dart';

class Preferences {
  static const _preferencesBox = '_preferencesBox';
  static const _userKey = '_user';
  static const _studentKey = 'st_key';
  static const _parentKey = 'pr_key';
  static const _loginKey = 'lg_key';
  static const _selectionKey = 'lg_key';
  static const _token = 'token';
  final Box<dynamic> _box;

  Preferences._(this._box);

  // This doesn't have to be a singleton.
  // We just want to make sure that the box is open, before we start getting/setting objects on it
  static Future<Preferences> getInstance() async {
    final box = await Hive.openBox<dynamic>(_preferencesBox);

    return Preferences._(box);
  }
  

  String getToken() => _getValue(_token);
  Future<void> setToken(String token) => _setValue(_token, token);

  String getUserType() => _getValue(_userKey);
  Future<void> setUserType(String type) => _setValue(_userKey, type);

  bool isLoggedIn() => _getValue(_loginKey);
  Future<void> setIsLoggedIn(bool log) => _setValue(_loginKey, log);

  String getStudentID() => _getValue(_studentKey);
  Future<void> setStudentID(String id) => _setValue(_studentKey, id);

  String getParentID() => _getValue(_parentKey);
  Future<void> setParentID(String id) => _setValue(_parentKey, id);

  int getSelectedChild() => _getValue(_selectionKey);
  Future<void> setSelectedChild(int pos) => _setValue(_selectionKey, pos);


  T _getValue<T>(dynamic key, {T defaultValue}) =>
      _box.get(key, defaultValue: defaultValue) as T;

  Future<void> _setValue<T>(dynamic key, T value) => _box.put(key, value);
}
