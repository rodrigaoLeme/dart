//import 'package:bibleplan/appstyle.dart';
import 'package:bibleplan/common.dart';

class ReadingCell extends StatelessWidget {
  final String reference;
  final String title;
  final String? subtitle;

  const ReadingCell(
      {Key? key, required this.reference, required this.title, this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return AppTheme.surface(
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(AppStyle.roundedCorner))),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(AppStyle.defaultMargin),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Txt(reference, style: AppStyle.fancyFont, size: 10),
                    const SizedBox(height: 5),
                    Txt.s(title, 24, style: AppStyle.fancyFont),
                    if (subtitle != null)
                      Txt(subtitle!, style: AppStyle.fancyFont, size: 14),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const CircularButton.alt(
                child: Icon(Icons.arrow_forward_ios, size: 14),
                onPressed: null,
              )
            ],
          ),
        ),
      ),
    );
  }
}
