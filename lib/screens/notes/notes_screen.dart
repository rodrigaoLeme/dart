// ignore_for_file: prefer_is_empty

import 'package:bibleplan/common.dart';
import 'package:bibleplan/providers/highlights_provider.dart';
import 'package:bibleplan/providers/Model/highlight.dart';
import 'package:bibleplan/providers/notes_provider.dart';
import 'package:bibleplan/providers/study_provider.dart';
import 'package:bibleplan/screens/notes/notes_filter_screen.dart';
import 'package:bibleplan/screens/notes/widgets/notes_menu.dart';
import 'package:bibleplan/screens/reading/readingscreen.dart';
import 'package:bibleplan/screens/reading/widgets/note_writer_widget.dart';
import 'package:bibleplan/shared/widgets/multi_section_selector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NotesItem {
  BooksHighlights book;
  ChapterHighlights? chapter;

  NotesItem({required this.book, this.chapter});
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<NotesItem> itens = [];
  NotesFilter? filter;
  ValueNotifier<int> tabIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    refreshList();
    tabIndex.addListener(tabChanged);
  }

  @override
  void dispose() {
    tabIndex.removeListener(tabChanged);
    super.dispose();
  }

  void tabChanged() {
    setState(() {
      refreshList();
    });
  }

  bool _includeBook(String bookKey) {
    return filter == null ||
        ((filter?.bibleBooks?.length ?? 0) == 0 &&
            (filter?.egwBooks?.length ?? 0) == 0) ||
        filter?.bibleBooks?.contains(bookKey) == true ||
        filter?.egwBooks?.contains(bookKey) == true;
  }

  bool _includeMark(TextMark mark) {
    if (filter == null) return true;
    if (filter?.color != null && filter?.color?.value != mark.color) {
      return false;
    }

    if (filter?.from != null && filter!.from!.compareTo(mark.date) >= 0) {
      return false;
    }
    if (filter?.to != null &&
        filter!.to!.add(const Duration(days: 1)).compareTo(mark.date) <= 0) {
      return false;
    }
    return true;
  }

  void refreshList() {
    var ah = tabIndex.value == 0
        ? NotesProvider.shared.all()
        : HighlightsProvider.shared.all();
    itens = [];

    for (var book in ah) {
      if (!_includeBook(book.key)) continue;

      List<NotesItem> chapters = [];

      for (var chapter in book.chapters) {
        if (chapter.marks.where(_includeMark).length > 0) {
          chapters.add(NotesItem(book: book, chapter: chapter));
        }
      }
      if (chapters.length > 0) {
        itens.add(NotesItem(book: book));
        itens.addAll(chapters);
      }
    }
  }

  String when(DateTime datetime) {
    var now = DateTime.now();
    var dif = now.difference(datetime);
    if (dif.inDays == 0 && now.day == datetime.day) return "HOJE";

    if (dif.inDays == 0 || dif.inDays == 1) return "ONTEM";

    if (dif.inDays < 30) {
      return "${dif.inDays} DIAS ATRÁS";
    }

    return "${datetime.day.zeroPadded(2)}/${datetime.month.zeroPadded(2)}/${datetime.year}";
  }

  void textMarkOption(
      NotesItem item, TextMark mark, NotesMenuOption option) async {
    switch (option) {
      case NotesMenuOption.delete:
        item.chapter?.removeMark(mark);
        if (tabIndex.value == 0) {
          NotesProvider.shared
              .save(item.book.name, item.book.key, item.chapter!);
        } else {
          HighlightsProvider.shared
              .save(item.book.name, item.book.key, item.chapter!);
        }
        setState(() {
          refreshList();
        });
        break;
      case NotesMenuOption.open:
        var dayInfo = StudyProvider.instance.currentPlan!.days[mark.day];
        pushScreen(context, ReadingScreen(dayInfo));
        break;
      case NotesMenuOption.edit:
        var text = await showBottomWidget(
            context: context, child: NoteWriterWidget(initialText: mark.note));
        if (text != null) {
          mark.note = text;
          NotesProvider.shared
              .save(item.book.name, item.book.key, item.chapter!);
        }
        break;
    }
  }

  Widget textMarkWidget(BuildContext context, TextMark mark) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Txt.b("${mark.reference}", color: AppStyle.primaryColor, size: 14),
          const VSpacer(8),
          Txt("${mark.description}"),
          const VSpacer(16),
          Row(
            children: [
              if (mark.color != 0)
                Container(
                  height: 6,
                  width: 44,
                  decoration: BoxDecoration(
                      color: Color(mark.color),
                      borderRadius: BorderRadius.circular(3)),
                ),
              if (mark.color != 0) const HSpacer(16),
              Txt(
                when(mark.date),
                size: 12,
                color: AppStyle.primaryColor.withAlpha(200),
              ),
              const Spacer(),
              Icon(
                FontAwesomeIcons.ellipsisVertical,
                size: 18,
                color: AppStyle.primaryColor,
              )
            ],
          ),
          const VSpacer(16),
          const Divider()
        ],
      ),
    );
  }

  Widget listItem(BuildContext context, int index) {
    var item = itens[index];

    if (item.chapter == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Txt.b(
            item.book.name,
            color: AppStyle.primaryColor,
          ),
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ...item.chapter!.marks.where(_includeMark).map(
                (e) => InkWell(
                  onTap: () async {
                    var res = await showBottomWidget(
                        context: context,
                        child: NotesMenu(
                          withEdit: e.color == 0,
                        ));
                    if (res != null) textMarkOption(item, e, res);
                  },
                  child: textMarkWidget(context, e),
                ),
              ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Txt(localize("NOTES AND HIGHLIGHTS")),
        actions: [
          IconButton(
            onPressed: () async {
              var result = await pushScreen(
                  context, NotesFilterScreen(filter: filter),
                  fullscreenDialog: true);
              setState(
                () {
                  filter = result ?? filter;
                  if (filter?.color == null &&
                      (filter?.bibleBooks?.length ?? 0) == 0 &&
                      (filter?.egwBooks?.length ?? 0) == 0 &&
                      filter?.to == null &&
                      filter?.from == null) {
                    filter = null;
                  }
                  refreshList();
                },
              );
            },
            icon: const Icon(
              FontAwesomeIcons.filter,
              size: 19,
            ),
          )
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: MultiSectionSelector(
              sections: [localize("Notes"), localize("Highlights")],
              indexController: tabIndex,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: itens.length,
        itemBuilder: listItem,
        padding: const EdgeInsets.only(bottom: 48),
      ),
    );
  }
}
