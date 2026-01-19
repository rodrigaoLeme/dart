import '../../../presentation/presenters/forms_details/forms_details_view_model.dart';
import '../../../presentation/presenters/status/status_view_model.dart';
import '../share/generic_error_entity.dart';

class StatusPageParams {
  final GenericErrorEntity? errorEntity;
  final StatusCardState status;
  final FormsDetailsViewModel? viewModel;

  StatusPageParams({
    required this.errorEntity,
    required this.status,
    required this.viewModel,
  });
}
