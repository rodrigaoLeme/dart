import 'package:bibleplan/common.dart';
import 'package:bibleplan/data/study_plan.dart';
import 'package:bibleplan/providers/egw_books_provider.dart';
import 'package:bibleplan/providers/language_provider.dart';
import 'package:bibleplan/providers/reading_progress_provider.dart';

class GuidDayInfo extends StatefulWidget {
  final StudyPlanDayInfo dayInfo;
  final bool highlight;

  const GuidDayInfo({Key? key, required this.dayInfo, this.highlight = false})
      : super(key: key);

  @override
  _GuidDayInfoState createState() => _GuidDayInfoState();
}

class _GuidDayInfoState extends State<GuidDayInfo> {
  @override
  Widget build(BuildContext context) {
    var info = widget.dayInfo;
    var monthsAbrev = Language.monthsShort;
    var egwCap = info.egwReading?.chapterIndex == 0
        ? "${info.egwReading?.chapter}"
        : "${localize('chap')} ${info.egwReading?.chapterIndex}";
    var isComplete = ReadingProgressProvider.instance.isDayCompleted(info);

    return SafeArea(
      child: DefaultTextStyle(
        style: DefaultTextStyle.of(context).style.copyWith(
            color: widget.highlight
                ? Colors.white
                : isComplete
                    ? AppStyle.primaryColor.withAlpha(120)
                    : AppStyle.primaryColor),
        child: Container(
          color: widget.highlight ? AppStyle.primaryColor : Colors.transparent,
          child: SizedBox(
            height: 62,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 16, right: 0, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Txt.b(info.date.day.toString(), size: 14),
                        Txt.b(monthsAbrev[info.date.month - 1].toUpperCase(),
                            size: 14)
                      ]),
                  const HSpacer(16),
                  Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          if (info.bibleChapters?.isNotEmpty == true)
                            Txt(
                                info.bibleChapters!
                                    .map((f) => f.reference)
                                    .join(", "),
                                overflow: TextOverflow.ellipsis,
                                size: 16),
                          if (info.egwReading != null)
                            Txt(
                                EGWBooksProvider.instance
                                        .bookName(info.egwReading!.book)! +
                                    ", $egwCap",
                                overflow: TextOverflow.ellipsis,
                                size: 16)
                        ]),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (info.day <
                            ReadingProgressProvider
                                .instance.planProgress!.length) {
                          ReadingProgressProvider
                              .instance.planProgress![info.day]
                              .toggleCompletion();
                        } else {
                          ReadingProgressProvider.instance.planProgress![364]
                              .toggleCompletion();
                        }
                        ReadingProgressProvider.instance.saveProgress();
                      });
                    },
                    child: Container(
                      color: widget.highlight
                          ? AppStyle.primaryColor
                          : Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Material(
                            color: isComplete
                                ? AppStyle.primaryColor
                                : Colors.white,
                            shape: CircleBorder(
                                side: BorderSide(
                                    color: AppStyle.primaryColor, width: 2)),
                            child: SizedBox(
                                width: 30,
                                height: 30,
                                child: isComplete
                                    ? const Icon(Icons.check,
                                        color: Colors.white, size: 18)
                                    : Container())),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
