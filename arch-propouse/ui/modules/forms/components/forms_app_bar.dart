import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/i18n/resources.dart';
import '../forms_presenter.dart';

class FormsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final FormsPresenter presenter;

  const FormsAppBar({super.key, required this.presenter});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AdraColors.primary,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: AdraText(
            text: R.string.formsLabel,
            textSize: AdraTextSizeEnum.h3w5,
            textStyleEnum: AdraTextStyleEnum.regular,
            color: AdraColors.white,
            adraStyles: AdraStyles.poppins,
            textAlign: TextAlign.left,
          ),
        ),
      ),
      actions: [
        ValueListenableBuilder(
          valueListenable: presenter.userNotifier,
          builder: (context, user, _) {
            final photoUrl = user?.photoUrl;
            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: presenter.goToProfile,
                child: ClipOval(
                  child: photoUrl != null && photoUrl.isNotEmpty
                      ? Image.network(
                          photoUrl,
                          width: 40.0,
                          height: 40.0,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              color: Colors.white,
                            );
                          },
                        )
                      : const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 32,
                        ),
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
