import 'dart:math';

import 'package:bibleplan/common.dart';
import 'package:bibleplan/data/study_plan.dart';
import 'package:bibleplan/providers/reading_progress_provider.dart';
import 'package:bibleplan/providers/study_provider.dart';
import 'package:bibleplan/screens/guide/widgets/guid_day_info.dart';
import 'package:bibleplan/screens/reading/readingscreen.dart';

class GuideScreen extends StatefulWidget {
  const GuideScreen({Key? key}) : super(key: key);

  @override
  _GuideScreenState createState() => _GuideScreenState();
}

class _GuideScreenState extends State<GuideScreen> {
  final StudyPlan? _plan = StudyProvider.instance.currentPlan;
  List<StudyPlanDayInfo>? _days;
  int todayDay = 0;
  final Bible? bible = BibleProvider.instance.bible;
  ScrollController? _listScrollController;
  int filter = 0;

  void _updateDays() {
    switch (filter) {
      case 1:
        _days = _plan!.days
            .where((element) =>
                !ReadingProgressProvider.instance.isDayCompleted(element))
            .toList();
        break;
      case 2:
        _days = _plan!.days
            .where((element) =>
                ReadingProgressProvider.instance.isDayCompleted(element))
            .toList();
        break;
      default:
        _days = _plan!.days;
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    todayDay = now.difference(DateTime(now.year, 1, 1)).inDays;
    _updateDays();
    _listScrollController =
        ScrollController(initialScrollOffset: (todayDay * 60).toDouble());
  }

  Widget _studyDayInfoWidget(BuildContext context, StudyPlanDayInfo info) {
    return GestureDetector(
      child: GuidDayInfo(dayInfo: info, highlight: todayDay == info.day),
      onTap: () async {
        var hasBible = info.bibleChapters?.isNotEmpty == true;

        await pushScreen(
            context,
            ReadingScreen(
              info,
              initView:
                  hasBible ? ReadingScreenView.bible : ReadingScreenView.egw,
            ));
        setState(() {});
      },
    );
  }

  Widget _filterButton(String text, int filter) => RoundedButton.text(text,
      onPressed: () => _setFilter(filter),
      color: this.filter == filter
          ? AppStyle.primaryColor
          : AppStyle.secondaryColor,
      textStyle: TextStyle(
        color: this.filter == filter
            ? AppStyle.onPrimaryColor
            : AppStyle.onBackgroundColor,
        fontSize: 16,
      ));

  void _scrollToToday() {
    int index = 0;
    int lastDif = 365;

    for (var i = 0; i < (_days?.length ?? 0); i++) {
      if ((_days![i].day - todayDay).abs() < lastDif) {
        lastDif = (_days![i].day - todayDay).abs();
        index = i;
      }
    }

    double totalScroll = (_days?.length ?? 0) * 60;
    double height = MediaQuery.of(context).size.height - 150;
    double position = (index * 60).toDouble();

    if (position > totalScroll - height) {
      position = max(0, totalScroll - height);
    }

    _listScrollController?.jumpTo(position);
  }

  void _setFilter(int filter) {
    if (filter != this.filter) {
      setState(() {
        this.filter = filter;
        _updateDays();
      });
      _scrollToToday();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          title: Txt(localize("Reading Plan").toUpperCase()),
          bottom: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _filterButton(localize("All"), 0),
                  const HSpacer(10),
                  _filterButton(localize("Not Read"), 1),
                  const HSpacer(10),
                  _filterButton(localize("Read"), 2)
                ],
              ),
            ),
            preferredSize: const Size.fromHeight(40),
          ),
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          controller: _listScrollController,
          itemCount: _days!.length,
          itemBuilder: (context, index) =>
              _studyDayInfoWidget(context, _days![index]),
        ),
      ),
    );
  }
}
