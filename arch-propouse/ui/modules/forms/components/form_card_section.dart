import 'package:flutter/widgets.dart';

import '../../../../presentation/presenters/forms/forms_view_model.dart';
import 'form_card_cell.dart';

class FormCardSection extends StatelessWidget {
  final FormViewModel? viewModel;
  final Function(FormsViewModel?) onTap;

  const FormCardSection({
    super.key,
    required this.viewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final data = viewModel?.data ?? [];
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        final formsViewModel = data[index];
        return FormCardCell(
          viewModel: formsViewModel,
          onTap: onTap,
        );
      },
    );
  }
}
