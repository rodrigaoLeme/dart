import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/i18n/resources.dart';

class FormsDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const FormsDetailsAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AdraColors.primary,
      titleSpacing: 0,
      leading: IconButton(
        onPressed: Navigator.of(context).pop,
        icon: const Icon(
          Icons.arrow_back,
          color: AdraColors.white,
        ),
      ),
      title: Align(
        alignment: Alignment.centerLeft,
        child: AdraText(
          text: R.string.detailsLabel,
          textSize: AdraTextSizeEnum.h3w5,
          textStyleEnum: AdraTextStyleEnum.regular,
          color: AdraColors.white,
          adraStyles: AdraStyles.poppins,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
