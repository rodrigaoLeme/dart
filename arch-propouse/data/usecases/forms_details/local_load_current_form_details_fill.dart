import 'dart:convert';

import '../../../domain/entities/forms_details/forms_details_entity.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/forms_details/load_current_form_details_fill.dart';
import '../../cache/cache.dart';
import '../../models/forms_details/forms_details_model.dart';

class LocalLoadCurrentFormDetailsFill implements LoadCurrentFormDetailsFill {
  final SharedPreferencesStorage sharedPreferencesStorage;

  LocalLoadCurrentFormDetailsFill({
    required this.sharedPreferencesStorage,
  });

  @override
  Future<FormsDetailsEntity?> load(String key) async {
    try {
      final data = await sharedPreferencesStorage.fetch(
        '${SecureStorageKey.formDetailsFill}/$key',
      );

      if (data == null || data == 'null') return null;
      final json = jsonDecode(data);
      final model = FormsDetailsModel.fromJson(json).toEntity();
      return model;
    } catch (error) {
      throw DomainError.unexpected;
    }
  }
}
