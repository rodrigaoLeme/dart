import 'package:bibleplan/common.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bibleplan/providers/notes_provider.dart';
import 'package:bibleplan/providers/study_provider.dart';
import 'package:bibleplan/providers/Model/highlight.dart';
import 'package:bibleplan/providers/language_provider.dart';
import 'package:bibleplan/providers/settings_provider.dart';
import 'package:bibleplan/providers/highlights_provider.dart';
import 'package:bibleplan/providers/reading_progress_provider.dart';

class AppSetup {
  static Future? _setup;

  AppSetup._();

  static Future setup(BuildContext context) =>
      _setup ??= _initialization(context);

  static Future _initialization(context) async {
    await SettingsProvider.instance.init(context);
    await Language.instance.init();
    await StudyProvider.instance.init();
    await ReadingProgressProvider.instance.init();
    await AudioManager.shared.listenForAudioPlayerEvents();
    await AudioProvider.shared.init();
    await Hive.initFlutter("highlights");
    Hive
      ..registerAdapter(BooksHighlightsAdapter())
      ..registerAdapter(ChapterHighlightsAdapter())
      ..registerAdapter(TextMarkAdapter());

    await HighlightsProvider.shared.init();
    await NotesProvider.shared.init();
  }
}
