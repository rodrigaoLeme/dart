import 'package:flutter/material.dart';
import 'countdown_store.dart';

class StartButton extends StatelessWidget {
  final CountdownStore store;

  const StartButton({required this.store});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (!store.isCounting) {
          store.startCountdown(
              1, 30, 0); // Defina as horas, minutos e segundos iniciais aqui
        }
      },
      child: Text('Start'),
    );
  }
}
