//import 'package:bibleplan/appstyle.dart';
import 'package:bibleplan/common.dart';

class MultiSectionSelector extends StatefulWidget {
  final List<String> sections;
  final ValueNotifier<int> indexController;

  const MultiSectionSelector(
      {Key? key, required this.sections, required this.indexController})
      : super(key: key);

  @override
  _MultiSectionSelectorState createState() => _MultiSectionSelectorState();
}

class _MultiSectionSelectorState extends State<MultiSectionSelector> {
  Widget _activeWidget(String section) {
    return AppTheme.surface(
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppStyle.defaultMargin, vertical: AppStyle.tinyMargin),
        decoration: BoxDecoration(
          color: AppStyle.primaryColor,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Txt.caption(section),
      ),
    );
  }

  Widget _buttonWidget(String section, int index) {
    return RoundedButton.text(
      section,
      onPressed: () {
        widget.indexController.value = index;
      },
      color: AppStyle.secondaryColor,
      textStyle: TextStyle(color: AppStyle.onBackgroundColor, fontSize: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
        valueListenable: widget.indexController,
        builder: (context, value, child) {
          List<Widget> _sections = [];

          for (var i = 0; i < widget.sections.length; i++) {
            if (i == value) {
              _sections.add(_activeWidget(widget.sections[i]));
            } else {
              _sections.add(_buttonWidget(widget.sections[i], i));
            }
          }

          return Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: AppStyle.secondaryColor,
                borderRadius: BorderRadius.circular(44)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _sections,
            ),
          );
        });
  }
}
