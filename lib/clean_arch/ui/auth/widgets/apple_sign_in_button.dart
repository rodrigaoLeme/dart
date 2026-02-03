import 'package:bibleplan/shared/widgets/easytext.dart';
import 'package:flutter/material.dart';

class AppleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String textButton;

  const AppleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.textButton = 'Continue with Apple',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeAlign: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00668C)),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.apple,
                    size: 40,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Txt.b(
                    textButton,
                    size: 18,
                    color: const Color(0xFF00668C),
                  ),
                ],
              ),
      ),
    );
  }
}
