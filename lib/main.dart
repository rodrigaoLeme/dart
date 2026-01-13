import 'package:bibleplan/providers/settings_provider.dart';
import 'package:bibleplan/screens/splash/splashscreen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'common.dart';

//void main() => runApp(const MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SettingsProvider.instance.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bíblia',
      navigatorObservers: [MyApp.observer],
      themeMode: SettingsProvider.instance.appTheme,
      darkTheme: AppStyle.buildTheme(context, ThemeMode.dark),
      theme: AppStyle.buildTheme(context, ThemeMode.light),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
