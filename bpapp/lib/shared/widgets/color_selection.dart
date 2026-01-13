import 'package:bibleplan/common.dart';

class ColorSelection extends StatelessWidget {
  final Color color;
  final List<Color>? gradient;
  final bool selected;

  const ColorSelection(
      {Key? key,
      this.color = Colors.white,
      this.gradient,
      this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var colors = gradient ?? [color, color];
    var borderColor = gradient?.first ?? color;

    var circle = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox.square(
        dimension: 40,
        child: selected
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 2),
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.all(4),
                child: circle,
              )
            : circle,
      ),
    );
  }
}
