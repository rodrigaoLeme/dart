import 'package:flutter/material.dart';

import '../../../../data/usecases/form_fill/remote_add_form_fill.dart';
import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../components/adra_colors.dart';
import '../../../components/adra_text.dart';
import '../../../components/enum/adra_size_enum.dart';
import '../../../components/theme/adra_styles.dart';
import 'edit_delete_action_sheet.dart';

class UserCard extends StatelessWidget {
  final RemoteFormsFill subForm;
  final void Function(SessionViewModel)? onTapEdit;
  final void Function()? onTapDelete;
  final List<SessionViewModel>? sessions;
  final void Function()? onPressed;

  const UserCard({
    super.key,
    required this.subForm,
    this.onTapEdit,
    this.onTapDelete,
    required this.sessions,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AdraColors.secondaryFixed,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.man,
                  color: AdraColors.secundary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: subForm.sessions?.isEmpty == true
                        ? 0
                        : ((subForm.sessions?.first?.questions?.length ?? 0) < 3
                            ? subForm.sessions?.first?.questions?.length
                            : 3),
                    itemBuilder: (context, index) {
                      if (subForm.sessions?.isEmpty == true) {
                        return const SizedBox.shrink();
                      }
                      final question = subForm.sessions?[0]?.questions?[index];
                      return AdraText(
                        text: question?.answer ?? '',
                        textSize: AdraTextSizeEnum.headline,
                        textStyleEnum: AdraTextStyleEnum.bold,
                        color: AdraColors.black,
                        adraStyles: AdraStyles.poppins,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: AdraColors.primary,
            ),
            onPressed: () {
              EditDeleteActionSheet.showEditDeleteActionSheet(
                context,
                sessions,
                onTapEdit,
                onTapDelete,
              );
            },
          ),
        ],
      ),
    );
  }
}
