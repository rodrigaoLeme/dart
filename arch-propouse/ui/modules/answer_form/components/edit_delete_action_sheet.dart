import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../components/components.dart';
import '../../../helpers/i18n/resources.dart';
import '../../forms_details/components/edit_action_sheet.dart';

class EditDeleteActionSheet extends StatelessWidget {
  final void Function(SessionViewModel)? onTapEdit;
  final void Function()? onTapDelete;
  final List<SessionViewModel>? sessions;

  const EditDeleteActionSheet({
    super.key,
    this.onTapEdit,
    this.onTapDelete,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: SvgPicture.asset(
                'lib/ui/assets/images/icon/xmark-regular.svg',
                height: 20,
                width: 15,
                color: AdraColors.black,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        ListTile(
          leading: SvgPicture.asset(
            'lib/ui/assets/images/icon/pen-to-square-solid.svg',
            height: 16,
            width: 16,
            color: AdraColors.primary,
          ),
          title: AdraText(
            text: R.string.editBase,
            adraStyles: AdraStyles.poppins,
            color: AdraColors.primary,
            textSize: AdraTextSizeEnum.body,
            textStyleEnum: AdraTextStyleEnum.regular,
          ),
          onTap: () {
            Navigator.pop(context);
            EditActionSheet.showEditActionSheet(
              context,
              onTapEdit,
              sessions ?? [],
            );
          },
        ),
        ListTile(
          leading: SvgPicture.asset(
            'lib/ui/assets/images/icon/trash-can-solid.svg',
            height: 16,
            width: 16,
            color: AdraColors.primary,
          ),
          title: AdraText(
            text: R.string.deleteLabel,
            adraStyles: AdraStyles.poppins,
            color: AdraColors.primary,
            textSize: AdraTextSizeEnum.body,
            textStyleEnum: AdraTextStyleEnum.regular,
          ),
          onTap: () {
            Navigator.pop(context);
            if (onTapDelete != null) {
              onTapDelete!();
            }
          },
        ),
      ],
    );
  }

  static void showEditDeleteActionSheet(
    BuildContext context,
    List<SessionViewModel>? sessions,
    void Function(SessionViewModel)? onTapEdit,
    void Function()? onTapDelete,
  ) {
    showModalBottomSheet(
      backgroundColor: AdraColors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
          child: EditDeleteActionSheet(
            sessions: sessions,
            onTapEdit: onTapEdit,
            onTapDelete: onTapDelete,
          ),
        );
      },
    );
  }
}
