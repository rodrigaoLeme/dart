import 'package:bibleplan/common.dart';
import 'package:bibleplan/providers/egw_books_provider.dart';
import 'package:bibleplan/providers/language_provider.dart';
import 'package:bibleplan/providers/reading_progress_provider.dart';
import 'package:bibleplan/providers/settings_provider.dart';
import 'package:bibleplan/providers/study_provider.dart';
import 'package:bibleplan/screens/settings/about_screen.dart';
import 'package:bibleplan/screens/settings/notification_configuration.dart';
import 'package:bibleplan/screens/settings/Widgets/notification_list.dart';
import 'package:share_plus/share_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  void _setLanguage(String lg) async {
    await Language.instance.setLanguage(lg);
    EGWBooksProvider.instance.reset();
    await StudyProvider.instance.init();
    Navigator.of(context).pop(true);
  }

  void _optionsDialog(BuildContext context, List<String> options, String title,
      Function(int index) callback) {
    List<Widget> widgets = [];

    for (var i = 0; i < options.length; i++) {
      widgets.add(TextButton(
          child: Txt(options[i]),
          onPressed: () {
            callback(i);
            Navigator.pop(context);
          }));
    }

    showDialog(
      context: context,
      barrierColor: Colors.grey.withAlpha(100),
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppStyle.backgroundColor,
          title: Txt.b(title),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widgets,
            ),
          ),
        );
      },
    );
  }

  void _languageDialog(BuildContext context) {
    _optionsDialog(
      context,
      ["Português", "Español", "English", "Français", "中文"],
      localize("choose your language"),
      (index) {
        switch (index) {
          case 0:
            _setLanguage("pt");
          case 1:
            _setLanguage("es");
          case 2:
            _setLanguage("en");
          case 3:
            _setLanguage("fr");
          case 4:
            _setLanguage("zh-CN");
          default:
            _setLanguage("en");
        }
      },
    );
  }

  String _language() {
    var languageString = Language.instance.current;
    switch (languageString) {
      case "pt":
        return "Português";
      case "es":
        return "Español";
      case "en":
        return "English";
      case "fr":
        return "Français";
      case "zh-CN":
        return "中文";
      default:
        return "English";
    }
  }

  void confirmReset(BuildContext context) {
    Widget cancelButton = TextButton(
      child: Text(localize("No")),
      onPressed: () {
        popScreen(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(localize("Yes")),
      onPressed: () {
        ReadingProgressProvider.instance.reset();
        popScreen(context);
      },
    );
    AlertDialog alert = AlertDialog(
      backgroundColor: AppStyle.backgroundColor,
      title: Text(localize("Warning")),
      content: Text(
          localize("Are you sure that you want to reset your reading plan?")),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _shareApp() {
    const String appStoreUrl =
        'https://apps.apple.com/br/app/bible-plan/id1505662639';
    const String playStoreUrl =
        'https://play.google.com/store/apps/details?id=org.adventistas.bibliaplan';

    final String message = '''
  ${localize("CheckOutThisApp")}

  Android: $playStoreUrl

  iOS: $appStoreUrl
  ''';

    SharePlus.instance.share(ShareParams(
      text: message,
      subject: localize("ShareAppSubject"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
          appBar: AppBar(title: Txt(localize("settings").toUpperCase())),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Cell(
                    child: Txt.s(localize("language"), 18),
                    accessory: Txt.s(_language(), 18),
                    onPressed: () => _languageDialog(context),
                  ),
                  const Divider(),
                  Cell(
                      child: Txt.s(localize("Dark Mode"), 18),
                      accessory: Switch.adaptive(
                        activeColor: AppStyle.primaryVariant,
                        inactiveTrackColor: AppStyle.secondaryVariant,
                        value: SettingsProvider.instance.appTheme ==
                            ThemeMode.dark,
                        onChanged: (value) {
                          setState(() {
                            SettingsProvider.instance.appTheme =
                                value ? ThemeMode.dark : ThemeMode.light;
                          });
                        },
                      )),
                  const Divider(),
                  Cell(child: Txt.s(localize("Reminders"), 18)),
                  const NotificationList(),
                  Cell(
                    child: Row(
                      children: [
                        Icon(Icons.add, color: AppStyle.primaryColor),
                        Txt.s(localize("Add reminder"), 18,
                            color: AppStyle.primaryColor),
                      ],
                    ),
                    onPressed: () async {
                      await pushScreen(
                          context, const NotificationConfiguration(),
                          fullscreenDialog: true);
                      setState(() {});
                    },
                  ),
                  const Divider(),
                  Cell(
                    onPressed: () {
                      confirmReset(context);
                    },
                    child: Txt.s(localize("Reset Plan"), 18),
                  ),
                  const Divider(),
                  Cell(
                    onPressed: () {
                      _shareApp();
                    },
                    child: Txt.s(localize("ShareApp"), 18),
                    accessory: Icon(
                      Icons.share,
                      color: AppStyle.primaryColor,
                    ),
                  ),
                  const Divider(),
                  Cell(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AboutScreen(),
                        settings: const RouteSettings(name: 'About'),
                      ));
                    },
                    child: Txt.s(localize("about"), 18),
                    accessory: Icon(
                      Icons.arrow_forward_ios,
                      color: AppStyle.primaryColor,
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          )),
    );
  }
}
