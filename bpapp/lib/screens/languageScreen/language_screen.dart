import 'package:flutter/material.dart';
import 'package:bibleplan/common.dart';
import 'package:bibleplan/providers/language_provider.dart';
import 'package:bibleplan/screens/tour/tour_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({Key? key}) : super(key: key);

  void _setLanguage(BuildContext context, String languageCode) async {
    await Language.instance.setLanguage(languageCode);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const TourScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Choose your language",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () => _setLanguage(context, "en"),
              child: const Text(
                "English",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () => _setLanguage(context, "pt"),
              child: const Text(
                "Português",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () => _setLanguage(context, "es"),
              child: const Text(
                "Español",
                style: TextStyle(fontSize: 18),
              ),
            ),
            const Divider(),
            TextButton(
              onPressed: () => _setLanguage(context, "fr"),
              child: const Text(
                "Français",
                style: TextStyle(fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () => _setLanguage(context, "zh-CN"),
              child: const Text(
                "中文",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
