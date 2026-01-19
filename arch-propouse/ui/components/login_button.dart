import 'package:flutter/material.dart';

import '../helpers/helpers.dart';

class LoginButton extends StatelessWidget {
  final Function() onAuth;
  final bool isFormValid;

  const LoginButton({
    super.key,
    required this.onAuth,
    required this.isFormValid,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColorDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.0),
          ),
          disabledBackgroundColor: Theme.of(context).canvasColor,
        ),
        onPressed: isFormValid ? onAuth : null,
        child: Text(
          R.string.next,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
