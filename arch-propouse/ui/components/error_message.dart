import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../share/utils/app_color.dart';
import '../helpers/helpers.dart';
import 'adra_colors.dart';

void showErrorMessage(BuildContext context, String error) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    duration: const Duration(seconds: 5),
    backgroundColor: AppColors.error,
    content: Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24.0, left: 16.0),
            child: SvgPicture.asset(
              'lib/ui/assets/images/icon/exclamation-circle.svg',
              width: 20,
              height: 20,
              color: AdraColors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
            child: Text(
              R.string.anErrorHasOccurred,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 16.0),
            child: Text(
              error,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  ));
}
