import '../forms/forms_view_model.dart';
import 'forms_details_view_model.dart';

abstract class FormsDetailsState {
  const FormsDetailsState();
}

class FormsDetailsLoading extends FormsDetailsState {
  const FormsDetailsLoading();
}

class FormsDetailsData extends FormsDetailsState {
  final FormsDetailsViewModel details;
  final FormsViewModel? forms;
  const FormsDetailsData({required this.details, required this.forms});
}

class FormsDetailsError extends FormsDetailsState {
  final Object error;
  const FormsDetailsError(this.error);
}
