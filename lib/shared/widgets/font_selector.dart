import 'package:bibleplan/common.dart';
import 'package:bibleplan/providers/settings_provider.dart';

class FontSelector extends StatelessWidget {
  final String font;
  final Function(String) onChange;
  const FontSelector({Key? key, required this.font, required this.onChange})
      : super(key: key);

  Widget _fontButton(String font) {
    //Function() onPressed = () => onChange(font);
    void onPressed() {
      onChange(font);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: this.font == font
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
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const HSpacer(AppStyle.defaultMargin),
          ...SettingsProvider.fontOptions.map(_fontButton).toList(),
          const HSpacer(AppStyle.defaultMargin),
        ],
      ),
    );
  }
}
