import 'package:flutter/cupertino.dart';

import '../../../../presentation/presenters/forms_details/forms_details_view_model.dart';
import 'info_card_cell.dart';

class InfoCardSection extends StatelessWidget {
  final FormsDetailsDataViewModel? viewModel;

  const InfoCardSection({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel == null) return const SizedBox.shrink();

    return InfoCardCell(viewModel: viewModel);
  }
}
