import '../../entities/forms_details/forms_details_entity.dart';

abstract class LoadCurrentFormDetailsFill {
  Future<FormsDetailsEntity?> load(String key);
}
