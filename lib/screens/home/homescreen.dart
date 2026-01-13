import 'package:bibleplan/common.dart';
import 'package:bibleplan/data/book.dart';
import 'package:bibleplan/data/study_plan.dart';
import 'package:bibleplan/providers/language_provider.dart';
import 'package:bibleplan/providers/reading_progress_provider.dart';
import 'package:bibleplan/providers/study_provider.dart';
import 'package:bibleplan/screens/downloads/download_screen.dart';
import 'package:bibleplan/screens/guide/guide_screen.dart';
import 'package:bibleplan/screens/home/widgets/mini_player.dart';
import 'package:bibleplan/screens/home/widgets/reading_cell.dart';
import 'package:bibleplan/screens/notes/notes_screen.dart';
import 'package:bibleplan/screens/reading/readingscreen.dart';
import 'package:bibleplan/screens/settings/settings_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Bible? bible;
  BookChapter? todayEGWChapter;
  StudyPlanDayInfo? today;
  GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(debugLabel: "NAVIGATOR");

  Future loadBible() async {
    switch (Language.instance.current) {
      case "pt":
        await BibleProvider.instance.openBible(BibleType.ara);
      case "es":
        await BibleProvider.instance.openBible(BibleType.rv);
      case "fr":
        await BibleProvider.instance.openBible(BibleType.lsg);
      case "zh-CN":
        await BibleProvider.instance.openBible(BibleType.cuv);
      case "en":
      default:
        await BibleProvider.instance.openBible(BibleType.esv);
    }
  }

  Widget titleText(String title, String text) => Column(
        children: <Widget>[
          Txt.subtitle1(title, style: GoogleFonts.roboto(), size: 14),
          Txt.bodyText1(text, weight: FontWeight.bold)
        ],
      );

  Future _todayInfo() async {
    var study = StudyProvider.instance.currentPlan!;
    var now = DateTime.now();
    var day = now.difference(DateTime(now.year, 1, 1));
    today = study.days[day.inDays];
    var todayRef = today!.egwReading;

    await loadBible();
    if (todayRef != null) {
      todayEGWChapter =
          (await Book.load(todayRef.book, Language.instance.current))!
              .chapters[todayRef.chapterIndex!];
    }
  }

  Widget _actionButton(IconData icon, String label, Function() onPressed) =>
      CircularButton.accent(
        child: Icon(icon, size: 20, color: AppStyle.onBackgroundColor),
        label: label,
        diameter: 48,
        onPressed: onPressed,
      );

  Future<Widget> _todaysReading(BuildContext context) async {
    await _todayInfo();

    var bibleChapters =
        today!.bibleChapters!.map((f) => f.reference).join("\n");

    var egwBookRef = today!.egwReading;
    Book? egwBook = egwBookRef != null
        ? await Book.load(egwBookRef.book, Language.instance.current)
        : null;
    BookChapter? egwChap =
        egwBook != null ? egwBook.chapters[egwBookRef!.chapterIndex!] : null;

    return DefaultTextStyle(
      style:
          Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
      child: Column(
        children: <Widget>[
          if (bibleChapters.isNotEmpty)
            GestureDetector(
              child: ReadingCell(
                  reference: localize("BIBLE"), title: bibleChapters),
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    settings: const RouteSettings(name: 'Reading'),
                    builder: (context) {
                      return ReadingScreen(today);
                    }));
                setState(() {});
              },
            ),
          const VSpacer(25),
          if (egwBook != null && egwChap != null)
            GestureDetector(
              child: ReadingCell(
                  reference: localize("SPIRIT OF PROPHECY"),
                  title: egwBook.name,
                  subtitle:
                      "${localize('chap')} ${egwChap.number} - ${egwChap.title}"),
              onTap: () async {
                await Navigator.of(context).push(MaterialPageRoute(
                    settings: const RouteSettings(name: 'Reading'),
                    builder: (context) {
                      return ReadingScreen(
                        today,
                        initView: ReadingScreenView.egw,
                      );
                    }));
                setState(() {});
              },
            ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Txt.headline5(localize("welcome")),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: AppStyle.primaryColor,
                  ),
                  onPressed: () async {
                    final result = await pushScreen(
                        context, const SettingsScreen(),
                        fullscreenDialog: true, root: true);
                    if (result == true) {
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
            const VSpacer(30),
            Txt.headline1(
                "${(ReadingProgressProvider.instance.totalProgress() * 100).toStringAsFixed(0)}%",
                style: AppStyle.fancyFont),
            Txt(localize("completed so far")),
            const VSpacer(20),
            FractionallySizedBox(
              widthFactor: 0.7,
              child: LinearProgressIndicator(
                minHeight: 5,
                value: ReadingProgressProvider.instance.totalProgress(),
                backgroundColor: AppStyle.secondaryColor,
                color: AppStyle.primaryColor,
              ),
            ),
            const VSpacer(30),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(),
                _actionButton(FontAwesomeIcons.clipboardList, localize("PLAN"),
                    () async {
                  await pushScreen(context, const GuideScreen());
                  setState(() {});
                }),
                const Spacer(),
                _actionButton(
                    FontAwesomeIcons.solidNoteSticky,
                    localize("NOTES AND HIGHLIGHTS HOME"),
                    () => pushScreen(context, const NotesScreen())),
                const Spacer(),
                _actionButton(
                    FontAwesomeIcons.download,
                    localize("DOWNLOADS BUTTON"),
                    () => pushScreen(context, const DownloadScreen())),
                const Spacer(),
              ],
            ),
            const VSpacer(30),
            const Row(children: <Widget>[]),
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Txt.headline4(localize("todays reading")),
              Txt(localize("read all bible in one year"), size: 13),
            ]),
            const VSpacer(20),
            FutureBuilder<Widget>(
              future: _todaysReading(context),
              builder: (context, snap) => snap.data ?? Text(localize("wait")),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MiniPlayer(),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;

          final shouldPop =
              await navigatorKey.currentState?.maybePop() == false;
          if (shouldPop && context.mounted) {
            Navigator.of(context).pop();
          }
        },
        child: Navigator(
          key: navigatorKey,
          onGenerateRoute: (settings) => MaterialPageRoute(
            settings: settings,
            builder: (context) => SafeArea(child: _body(context)),
          ),
        ),
      ),
    );
  }
}
