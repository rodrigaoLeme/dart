import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'components.dart';

class EmptyState extends StatelessWidget {
  final String? icon;
  final String title;

  const EmptyState({
    super.key,
    this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon ?? '',
            width: 52,
            height: 52,
            color: AdraColors.neutralLowMedium,
          ),
          const SizedBox(height: 16),
          AdraText(
            text: title,
            textAlign: TextAlign.center,
            textSize: AdraTextSizeEnum.callout,
            textStyleEnum: AdraTextStyleEnum.regular,
            color: AdraColors.neutralLowMedium,
            adraStyles: AdraStyles.poppins,
          ),
        ],
      ),
    );
  }
}
