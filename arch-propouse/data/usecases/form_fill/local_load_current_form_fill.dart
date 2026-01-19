import 'dart:convert';

import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/form_fill/load_current_form_fill.dart';
import '../../cache/cache.dart';
import 'remote_add_form_fill.dart';

class LocalLoadCurrentFormFill implements LoadCurrentFormFill {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalLoadCurrentFormFill({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<RemoteAddFormFillParams?> load({required String key}) async {
    try {
      final data = await sharedPreferencesStorage
          .fetch('${SecureStorageKey.formFill}$key');

      if (data == null) return null;
      final model = RemoteAddFormFillParams.fromJson(jsonDecode(data));
      return model;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
