abstract class SharedPreferencesStorage {
  Future<String?> fetch(String key);
  Future<void> clean();
  Future<void> save({required String key, required String value});
  Future<void> remove(String key);
}
