import '../../entities/forms_details/forms_details_entity.dart';

abstract class LoadFormsDetails {
  Future<FormsDetailsEntity> load(String? key);
}
