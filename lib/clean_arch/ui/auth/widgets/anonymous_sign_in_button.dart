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
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF0B7FA4),
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
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0B7FA4)),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    textButton,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00668C),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
