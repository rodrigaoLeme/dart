import 'package:bibleplan/shared/widgets/easytext.dart';
import 'package:flutter/material.dart';

class AnonymousSignInButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;
  final String textButton;

  const AnonymousSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.textButton = 'Continue without an account',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeAlign: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Txt.b(
                    textButton,
                    color: Colors.white,
                    size: 18,
                  )
          ],
        ),
      ),
    );
  }
}
