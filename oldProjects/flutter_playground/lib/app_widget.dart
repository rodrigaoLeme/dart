import 'package:flutter/material.dart';
import 'package:flutter_playground/home_page_animation.dart';
import 'home_page.dart';
import 'home_page_button.dart';
import 'home_page_explicit_animation.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.red),
      home: HomePage(),
    );
  }
}

class AppWidgetAnimation extends StatelessWidget {
  const AppWidgetAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePageAnimation(),
    );
  }
}

class AppWidgetExplicitAnimation extends StatelessWidget {
  const AppWidgetExplicitAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePageExplcitAnimation(),
    );
  }
}

class AppWidgetButtonAnimation extends StatelessWidget {
  const AppWidgetButtonAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePageButtonAnimation(),
    );
  }
}
