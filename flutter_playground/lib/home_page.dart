import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  var count = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: Container(
        color: Colors.red,
        width: 300,
        height: 300,
        alignment: Alignment.center,
        transformAlignment: Alignment.center,
        transform: Matrix4.identity()..rotateZ(pi / 4),
        child: Container(
          //color: Colors.green,
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(75),
            color: Colors.green,
          ),
        ),
      ),
    ));
  }
}
