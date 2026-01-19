import 'package:shared_preferences/shared_preferences.dart';

import '../../data/cache/cache.dart';

class SharedPreferencesStorageAdapter implements SharedPreferencesStorage {
  @override
  Future<void> save({required String key, required String value}) async {
    final localStorage = await SharedPreferences.getInstance();
    await localStorage.setString(key, value);
  }

  @override
  Future<void> clean() async {
    final localStorage = await SharedPreferences.getInstance();
    await localStorage.clear();
  }

  @override
  Future<void> remove(String key) async {
    final localStorage = await SharedPreferences.getInstance();
    await localStorage.remove(key);
  }

  @override
  Future<String?> fetch(String key) async {
    final localStorage = await SharedPreferences.getInstance();
    return localStorage.getString(key);
  }
}
