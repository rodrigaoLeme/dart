//import 'package:bibleplan/appstyle.dart';
import 'package:bibleplan/common.dart';
import 'package:bibleplan/providers/settings_provider.dart';

class SettingsModal extends StatefulWidget {
  const SettingsModal({Key? key}) : super(key: key);

  @override
  _SettingsModalState createState() => _SettingsModalState();
}

class _SettingsModalState extends State<SettingsModal> {
  void _increaseFont() {
    int options = SettingsProvider.instance.fontSizeOption + 1;
    if (options < SettingsProvider.sizeOptions.length) {
      SettingsProvider.instance.fontSizeOption = options;
    }
  }

  void _decreaseFont() {
    int options = SettingsProvider.instance.fontSizeOption - 1;
    if (options > 0) SettingsProvider.instance.fontSizeOption = options;
  }

  Widget _fontButton(String font) {
    //void Function() onPressed = () => SettingsProvider.instance.fontName = font;
    void onPressed() {
      SettingsProvider.instance.fontName = font;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SettingsProvider.instance.fontName == font
          ? RoundedButton.text(font,
              onPressed: onPressed,
              textStyle: SettingsProvider.styleForFont(font))
          : RoundedButton.secondary(
              child: Txt(font, style: SettingsProvider.styleForFont(font)),
              onPressed: onPressed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const VSpacer(8),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppStyle.defaultMargin),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: IconButton(
                color: AppStyle.primaryColor,
                icon: const Icon(Icons.close),
                onPressed: () {
                  popScreen(context);
                },
              ),
            ),
            const Spacer(),
            Txt.bs(localize("settings").toUpperCase(), 16,
                color: AppStyle.primaryColor),
            const Spacer(),
            const SizedBox(width: 30)
          ],
        ),
      ),
      const VSpacer(20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularButton.accent(
              diameter: 50,
              child: Txt.s("A-", 15, style: AppStyle.fancyFont),
              onPressed: _decreaseFont),
          const HSpacer(AppStyle.bigMargin),
          CircularButton.accent(
              diameter: 50,
              child: Txt.s("A+", 18, style: AppStyle.fancyFont),
              onPressed: _increaseFont),
        ],
      ),
      const VSpacer(20),
      const Divider(),
      const VSpacer(16),
      SizedBox(
        height: 44,
        child: AnimatedBuilder(
            animation: SettingsProvider.instance,
            builder: (context, child) {
              return ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  const HSpacer(AppStyle.defaultMargin),
                  ...SettingsProvider.fontOptions.map(_fontButton).toList(),
                  const HSpacer(AppStyle.defaultMargin),
                ],
              );
            }),
      ),
      const VSpacer(16),
      const Divider(),
      SafeArea(
        child: Cell(
          child: const Txt("Dark Mode"),
          accessory: Switch.adaptive(
            activeColor: AppStyle.primaryVariant,
            inactiveTrackColor: AppStyle.secondaryVariant,
            value: SettingsProvider.instance.appTheme == ThemeMode.dark,
            onChanged: (value) {
              setState(() {
                SettingsProvider.instance.appTheme =
                    value ? ThemeMode.dark : ThemeMode.light;
              });
            },
          ),
        ),
      )
    ]);
  }
}
