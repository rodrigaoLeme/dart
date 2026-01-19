import 'package:flutter/material.dart';

import '../../../components/components.dart';
import '../../../helpers/i18n/resources.dart';

class SessionHeader extends StatelessWidget {
  final int currentIndex; // 0-based
  final int total;
  final String? title;

  const SessionHeader({
    super.key,
    required this.currentIndex,
    required this.total,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 16.0, bottom: 12.0),
          child: AdraText(
            text: '${R.string.sessionLabel} ${currentIndex + 1}/$total',
            textSize: AdraTextSizeEnum.h3,
            textStyleEnum: AdraTextStyleEnum.bold,
            color: AdraColors.black,
            adraStyles: AdraStyles.poppins,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
          child: AdraText(
            text: title ?? '',
            textSize: AdraTextSizeEnum.subheadline,
            textStyleEnum: AdraTextStyleEnum.regular,
            color: AdraColors.secundary,
            adraStyles: AdraStyles.poppins,
          ),
        ),
      ],
    );
  }
}
