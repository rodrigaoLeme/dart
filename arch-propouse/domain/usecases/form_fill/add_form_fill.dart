import '../../../data/usecases/form_fill/remote_add_form_fill.dart';
import '../../entities/share/generic_error_entity.dart';

abstract class AddFormFill {
  Future<GenericErrorEntity?> add(RemoteAddFormFillParams params);
}
