import 'package:bibleplan/common.dart';
import 'package:bibleplan/data/book.dart';
import 'package:bibleplan/data/study_plan.dart';
import 'package:bibleplan/providers/language_provider.dart';
import 'package:bibleplan/providers/settings_provider.dart';
import 'package:bibleplan/screens/reading/widgets/biblereading.dart';
import 'package:bibleplan/screens/reading/widgets/bookreading.dart';
import 'package:bibleplan/screens/reading/widgets/settings_modal.dart';
import 'package:bibleplan/shared/widgets/multi_section_selector.dart';

enum ReadingScreenView { bible, egw }

class ReadingScreen extends StatefulWidget {
  final StudyPlanDayInfo? dayInfo;
  final ReadingScreenView initView;

  const ReadingScreen(this.dayInfo,
      {Key? key, this.initView = ReadingScreenView.bible})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  _ReadingScreenState createState() => _ReadingScreenState(initView);
}

class _ReadingScreenState extends State<ReadingScreen> {
  ReadingScreenView view;
  ValueNotifier<int> readingIndex;
  late DateTime day;

  Bible? bible;
  BookChapter? todayEGWChapter;

  _ReadingScreenState(this.view) : readingIndex = ValueNotifier(view.index);

  Future _load() async {
    bible = BibleProvider.instance.bible;
    var todayRef = widget.dayInfo!.egwReading;
    if (todayRef != null) {
      todayEGWChapter =
          (await Book.load(todayRef.book, Language.instance.current))!
              .chapters[todayRef.chapterIndex!];
    }
    var now = DateTime.now();
    day = DateTime(now.year, 1, 1).add(Duration(days: widget.dayInfo!.day));
  }

  bool showContentSelector() =>
      (widget.dayInfo?.bibleChapters?.length ?? 0) > 0 &&
      widget.dayInfo?.egwReading != null;

  Widget _egwReading(BuildContext context) {
    return BookReading(
      todayEGWChapter,
      widget.dayInfo!.day,
      () {
        readingIndex.value = 0;
      },
      showChangeContentButton: showContentSelector(),
    );
  }

  Widget _bibleReading(BuildContext context) {
    return BibleReading(
      widget.dayInfo!.bibleChapters,
      widget.dayInfo!.day,
      esPressed: () {
        readingIndex.value = 1;
      },
      showChangeContentButton: showContentSelector(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _load(),
        builder: (context, snapshot) {
          return AnimatedBuilder(
            animation: SettingsProvider.instance,
            builder: (context, child) {
              return Scaffold(
                appBar: AppBar(
                  title: Txt(localize("todays reading").toUpperCase()),
                  actions: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.format_size_outlined),
                      onPressed: () {
                        showBottomWidget(
                            context: context, child: const SettingsModal());
                      },
                    )
                  ],
                  bottom: showContentSelector()
                      ? PreferredSize(
                          preferredSize: const Size.fromHeight(40),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: MultiSectionSelector(
                              sections: [
                                localize("Bible"),
                                localize("Spirit of prophecy")
                              ],
                              indexController: readingIndex,
                            ),
                          ),
                        )
                      : null,
                ),
                body: SafeArea(
                  minimum: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: snapshot.connectionState != ConnectionState.done
                        ? Container()
                        : ValueListenableBuilder(
                            valueListenable: readingIndex,
                            builder: (context, value, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: value == 0
                                        ? _bibleReading(context)
                                        : _egwReading(context),
                                  )
                                ],
                              );
                            },
                          ),
                  ),
                ),
              );
            },
          );
        });
  }
}
