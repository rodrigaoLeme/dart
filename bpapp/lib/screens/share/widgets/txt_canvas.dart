import 'package:bibleplan/common.dart';
import 'package:bibleplan/providers/settings_provider.dart';

class TxtCanvas extends StatelessWidget {
  final String text;
  final String reference;
  final int colorIndex;
  final String font;
  final GlobalKey renderKey;

  const TxtCanvas(
      {Key? key,
      required this.text,
      required this.reference,
      required this.colorIndex,
      required this.font,
      required this.renderKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(32),
      child: Material(
        elevation: 10,
        child: RepaintBoundary(
          key: renderKey,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: AppStyle.shareColors[colorIndex],
                    stops: const [0, 1],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const VSpacer(8),
                    Txt.b(
                      "Bible Plan",
                      color: Colors.black,
                      size: 24,
                      style: SettingsProvider.styleForFont(font),
                    ),
                    //Txt("bibleplan.app", color: Colors.black, size: 20),
                    const VSpacer(16),
                    Txt(
                      text,
                      align: TextAlign.center,
                      size: 21,
                      //maxLines: 15,
                      //overflow: TextOverflow.ellipsis,
                      style: SettingsProvider.styleForFont(font),
                      color: Colors.black,
                    ),
                    const VSpacer(8),
                    Txt.b(
                      reference,
                      size: 19,
                      style: SettingsProvider.styleForFont(font),
                      color: Colors.black,
                    ),
                    const VSpacer(16),
                    Txt(
                      "bibleplan.app",
                      color: const Color(0xFF001326).withAlpha(180),
                      size: 14,
                      style: SettingsProvider.styleForFont(font),
                    ),
                    const VSpacer(10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
