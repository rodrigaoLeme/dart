import 'dart:js';

import 'package:flutter/material.dart';

void main() {
  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  var count = 0;

  @override
  Widget build(covariant Element context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: Text('Masterclass $count'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Click');
          count++;
          context.markNeedsBuild();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// class AppWidget extends Widget {
//   @override
//   Element createElement() {
//     return AppElement(this);
//   }
// }

// class AppElement extends ComponentElement {
//   AppElement(Widget widget) : super(widget);

//   @override
//   Widget build() {
//     return Container();
//   }
// }


// class AppWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Center(
//       child: Text('MasterClass', textDirection: TextDirection.ltr),
//     );
//   }
// }

// class AppWidget extends Widget {
//   @override
//   Element createElement() => AppElement(this);
//   // Element createElement() {
//   //   return AppElement(this);
//   // }
// }

// class AppElement extends ComponentElement {
//   AppElement(Widget widget) : super(widget);

//   @override
//   Widget build() {
//     return const Center(
//       child: Text('MasterClass', textDirection: TextDirection.ltr),
//     );
//   }
// }
