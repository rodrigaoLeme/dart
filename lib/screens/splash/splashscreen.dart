import 'dart:async';

import 'package:bibleplan/app_setup.dart';
import 'package:bibleplan/common.dart';
import 'package:bibleplan/screens/home/homescreen.dart';
import 'package:bibleplan/screens/languageScreen/language_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  final timeout = const Duration(seconds: 3);

  SplashScreen({Key? key}) : super(key: key) {
    startTimeout();
  }

  void startTimeout() {}

  void gotoApp(BuildContext context) async {
    var shared = await SharedPreferences.getInstance();
    int _opens = shared.getInt("APPOPENNUMBER") ?? 0;
    _opens++;
    shared.setInt("APPOPENNUMBER", _opens);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (p) =>
            _opens == 1 ? const LanguageSelectionScreen() : const HomeScreen(),
      ),
    );
  }

  void _setup(BuildContext context) async {
    await AppSetup.setup(context);
    Timer(timeout, () => gotoApp(context));
  }

  @override
  Widget build(BuildContext context) {
    _setup(context);
    return Scaffold(
      backgroundColor: const Color(0xFF007aa7),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(width: 100, child: Image.asset("assets/images/icon.png")),
          const SizedBox(height: 20),
        ],
      )),
    );
  }
}
