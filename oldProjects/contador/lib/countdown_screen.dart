import 'package:contador/start_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'countdown_store.dart';

final countdownStore = CountdownStore();

class CountdownScreen extends StatelessWidget {
  const CountdownScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contador Regressivo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  Observer(
                    builder: (_) => Text(
                      '${countdownStore.hours.toString().padLeft(2, '0')}:${countdownStore.minutes.toString().padLeft(2, '0')}:${countdownStore.seconds.toString().padLeft(2, '0')}',
                      style: TextStyle(fontSize: 48),
                    ),
                  ),
                  SizedBox(height: 20),
                  StartButton(store: countdownStore),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(home: CountdownScreen()));
