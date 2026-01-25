import 'dart:async';

import 'package:bibleplan/clean_arch/ui/auth/auth_state_wrapper.dart';
import 'package:bibleplan/common.dart';
import 'package:bibleplan/flavors.dart';
import 'package:bibleplan/screens/home/homescreen.dart';
import 'package:bibleplan/screens/languageScreen/language_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_setup.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final String flavorType;

  @override
  void initState() {
    super.initState();
    _setFlavorType();
    _initialize();
  }

  void _setFlavorType() {
    flavorType = (Flavor.flavorMessage == 'Dev') ? '-DEV' : '';
  }

  Future<void> _initialize() async {
    await Future.delayed(const Duration(seconds: 3));
    await AppSetup.setup(context);

    final prefs = await SharedPreferences.getInstance();

    int appOpenNumber = prefs.getInt('APPOPENNUMBER$flavorType') ?? 0;
    appOpenNumber++;
    prefs.setInt("APPOPENNUMBER$flavorType", appOpenNumber);

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (p) => appOpenNumber == 1
            ? const LanguageSelectionScreen()
            : const AuthStateWrapper(homeScreen: HomeScreen()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
