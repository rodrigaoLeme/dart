import 'package:bibleplan/common.dart';
import 'package:bibleplan/shared/widgets/color_selection.dart';

class ColorCollection extends StatelessWidget {
  final int colorSelected;
  final Function(int) onChange;
  const ColorCollection(
      {Key? key, required this.colorSelected, required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: AppStyle.shareColors
            .asMap()
            .entries
            .map(
              (e) => GestureDetector(
                onTap: () => onChange(e.key),
                child: ColorSelection(
                    selected: e.key == colorSelected, gradient: e.value),
              ),
            )
            .toList(),
      ),
    );
  }
}
