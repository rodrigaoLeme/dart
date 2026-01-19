import '../../../data/usecases/form_fill/remote_add_form_fill.dart';

abstract class LoadCurrentFormFill {
  Future<RemoteAddFormFillParams?> load({required String key});
}
