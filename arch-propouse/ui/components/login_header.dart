import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({ super.key });

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Image(
          image: AssetImage('lib/ui/assets/icon/logo.png'),
          height: 50,
          width: 50,
          ),
      ],
    );
  }
}