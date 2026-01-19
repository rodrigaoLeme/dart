import 'package:flutter/widgets.dart';

import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../../presentation/presenters/forms_details/forms_details_view_model.dart';
import '../forms_details_presenter.dart';
import 'list_status_details_cell.dart';

class ListStatusDetailsSection extends StatelessWidget {
  final List<LatestFormSendedViewModel>? viewModels;
  final void Function(LatestFormSendedViewModel?)? onPressed;
  final bool showRefreshIcon;
  final bool showMoreOptionsIcon;
  final List<SessionViewModel>? sessions;
  final void Function(SessionViewModel, LatestFormSendedViewModel?)? onTapEdit;
  final void Function(LatestFormSendedViewModel?)? onTapDelete;
  final FormsDetailsPresenter presenter;

  const ListStatusDetailsSection({
    super.key,
    this.onPressed,
    this.viewModels,
    required this.showRefreshIcon,
    required this.showMoreOptionsIcon,
    required this.sessions,
    this.onTapEdit,
    this.onTapDelete,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModels?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final item = viewModels?[index];
        return ListStatusDetailsCell(
          viewModel: item,
          onPressed: onPressed,
          showMoreOptionsIcon: showMoreOptionsIcon,
          showRefreshIcon: showRefreshIcon,
          sessions: sessions,
          onTapEdit: onTapEdit,
          onTapDelete: onTapDelete,
          presenter: presenter,
        );
      },
    );
  }
}
