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
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: SizedBox(
        width: mediaQuery.size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                color: Colors.red,
                width: 50,
                height: 50,
              ),
              //SizedBox(height: 10),
              Container(
                color: Colors.green,
                width: 50,
                height: 50,
              ),
              Container(
                color: Colors.yellow,
                width: 50,
                height: 50,
              ),
              Container(
                color: Colors.black,
                width: 50,
                height: 50,
              )
            ]),
      ),
    );
  }
}
