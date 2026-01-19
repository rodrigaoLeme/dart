import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../presentation/presenters/answer_form/answer_form_view_model.dart';
import '../../../components/components.dart';
import '../../../helpers/i18n/resources.dart';

class EditActionSheet extends StatelessWidget {
  final List<SessionViewModel>? sessions;
  final void Function(SessionViewModel)? onTapEdit;

  const EditActionSheet({
    super.key,
    required this.sessions,
    this.onTapEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdraText(
                text: R.string.chooseSessionToEdit,
                adraStyles: AdraStyles.poppins,
                color: AdraColors.black,
                textSize: AdraTextSizeEnum.h3,
                textStyleEnum: AdraTextStyleEnum.bold,
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                itemCount: sessions?.length ?? 0,
                itemBuilder: (context, index) {
                  final session = sessions?[index];
                  final sectionId = index + 1;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: GestureDetector(
                      onTap: () {
                        if (onTapEdit != null && session != null) {
                          Navigator.pop(context);
                          onTapEdit!(session);
                        }
                      },
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: AdraColors.hintColor,
                        ),
                        child: Center(
                          child: AdraText(
                            text: session?.title != ''
                                ? (session?.title ?? 'Sessão $sectionId')
                                : 'Sessão $sectionId',
                            adraStyles: AdraStyles.poppins,
                            color: AdraColors.primary,
                            textSize: AdraTextSizeEnum.body,
                            textStyleEnum: AdraTextStyleEnum.regular,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  static void showEditActionSheet(
    BuildContext context,
    void Function(SessionViewModel)? onTapEdit,
    List<SessionViewModel>? sessions,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AdraColors.white,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: EditActionSheet(
            sessions: sessions,
            onTapEdit: onTapEdit,
          ),
        );
      },
    );
  }
}
