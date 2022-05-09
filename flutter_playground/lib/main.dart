import 'package:flutter/material.dart';

void main() {
  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('MasterClass', textDirection: TextDirection.ltr),
    );
  }
}

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
