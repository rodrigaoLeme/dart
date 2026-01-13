import 'package:bibleplan/common.dart';
//import 'package:bibleplan/data/book.dart';
import 'package:bibleplan/shared/widgets/check_indicator.dart';

class DoneButton extends StatelessWidget {
  final bool checked;
  final Function()? onPressed;

  const DoneButton({Key? key, required this.checked, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RoundedButton.secondary(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CheckIndicator(value: checked),
            Txt.s(localize("done"), 18),
            const HSpacer(16)
          ],
        ),
        onPressed: onPressed);
  }
}
