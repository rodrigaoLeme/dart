import 'package:flutter/material.dart';

import '../../presentation/mixins/mixins.dart';
import '../../share/utils/app_color.dart';

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}

Future<void> showLoading(BuildContext context, LoadingData data) async {
  Future.delayed(Duration.zero, () async {
    await showDialog(
      barrierColor: data.style == LoadingStyle.light
          ? AppColors.primary.withAlpha(1)
          : AppColors.primary,
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleDialog(
        titlePadding: EdgeInsets.zero,
        elevation: 0,
        contentPadding: EdgeInsets.zero,
        shadowColor: data.style == LoadingStyle.light
            ? Colors.transparent
            : Theme.of(context).primaryColor,
        backgroundColor: data.style == LoadingStyle.light
            ? Colors.transparent
            : Theme.of(context).primaryColor,
        children: const <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                color: AppColors.primary,
              ),
              SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  });
}
