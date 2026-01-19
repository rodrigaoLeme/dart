import '../../entities/forms/forms_entity.dart';

abstract class LoadForms {
  Future<FormEntity> load();
}
