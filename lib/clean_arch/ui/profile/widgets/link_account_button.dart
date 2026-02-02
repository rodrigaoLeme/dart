import 'package:bibleplan/appstyle.dart';
import 'package:bibleplan/shared/localize.dart';
import 'package:bibleplan/shared/widgets/easytext.dart';
import 'package:flutter/material.dart';

class LinkAccountButton extends StatelessWidget {
  final String provider;
  final VoidCallback onPressed;
  final bool isLoading;

  const LinkAccountButton({
    super.key,
    required this.provider,
    required this.onPressed,
    this.isLoading = false,
  });

  String get _text {
    switch (provider.toLowerCase()) {
      case 'google':
        return localize('anonymousLinkedGoogleButton');
      case 'apple':
        return localize('anonymousLinkedAppleButton');
      default:
        return 'Linked';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppStyle.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(color: AppStyle.primaryColor, width: 1.5),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppStyle.primaryColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (provider.toLowerCase() == 'apple') ...[
                    const Icon(
                      Icons.apple,
                      size: 30,
                      color: Colors.black,
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                  ],
                  if (provider.toLowerCase() == 'google') ...[
                    Image.asset(
                      'assets/images/google.png',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                  ],
                  Txt(
                    _text,
                    size: 18,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
      ),
    );
  }
}
