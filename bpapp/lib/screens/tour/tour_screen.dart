import 'package:bibleplan/common.dart';
import 'package:bibleplan/screens/home/homescreen.dart';

class TourScreen extends StatefulWidget {
  const TourScreen({Key? key}) : super(key: key);

  @override
  _TourScreenState createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 40),
                const SizedBox(height: 20),
                Txt.s(localize("Presentation"), 30, weight: FontWeight.bold),
                const SizedBox(height: 40),
                Txt(localize("Presentation Text")),
                const SizedBox(height: 40),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(AppStyle.primaryColor),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  },
                  child: const SizedBox(
                    width: 30,
                    height: 44,
                    child: Icon(Icons.arrow_forward_ios, color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
