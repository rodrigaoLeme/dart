// ignore_for_file: prefer_is_empty

import 'dart:math';

import 'package:bibleplan/common.dart';
import 'package:bibleplan/data/book.dart';
import 'package:bibleplan/main.dart';
import 'package:bibleplan/providers/highlights_provider.dart';
import 'package:bibleplan/providers/Model/highlight.dart';
import 'package:bibleplan/providers/notes_provider.dart';
import 'package:bibleplan/providers/reading_progress_provider.dart';
import 'package:bibleplan/providers/settings_provider.dart';
import 'package:bibleplan/screens/reading/widgets/audio_display.dart';
import 'package:bibleplan/screens/reading/widgets/done_button.dart';
import 'package:bibleplan/screens/reading/widgets/note_writer_widget.dart';
import 'package:bibleplan/screens/reading/widgets/share_options.dart';
import 'package:bibleplan/screens/share/share_screen.dart';
import 'package:bibleplan/shared/widgets/selected_text_menu.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:share_plus/share_plus.dart';

class BookPageController {
  ScrollController controller = ScrollController();
  double? lastPosition;

  BookPageController() {
    controller.addListener(_scrollChanged);
  }

  void savePosition() => lastPosition = controller.offset;

  void dispose() {
    controller.removeListener(_scrollChanged);
  }

  void _scrollChanged() {
    if (lastPosition != null) {
      controller.jumpTo(lastPosition!);
      lastPosition = null;
    }
  }
}

class BookReading extends StatefulWidget {
  final BookChapter? chapter;
  final int readingDay;
  final bool showChangeContentButton;
  final Function()? biblePressed;
  const BookReading(this.chapter, this.readingDay, this.biblePressed,
      {this.showChangeContentButton = true, Key? key})
      : super(key: key);

  @override
  _BookReadingState createState() => _BookReadingState();
}

class _BookReadingState extends State<BookReading> {
  late List<String> _pages;
  PageController? _pageController;
  TextSelection? lastSelection;
  List<BookPageController> _textControllers = [];
  double? lastX;
  int lastPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    if (widget.chapter != null) {
      _pages = widget.chapter!.content!.split("¶");
    }

    _textControllers = _pages.map((e) => BookPageController()).toList();
  }

  @override
  void dispose() {
    for (var item in _textControllers) {
      item.dispose();
    }
    super.dispose();
  }

  void _setChapterCompletion(bool completed) {
    setState(() {
      if (ReadingProgressProvider.instance.planProgress!.length >
          widget.readingDay) {
        ReadingProgressProvider.instance.planProgress![widget.readingDay]
            .egwReadingCompleted = completed;
        ReadingProgressProvider.instance.saveProgress();

        if (ReadingProgressProvider
            .instance.planProgress![widget.readingDay].isComplete) {
          MyApp.analytics.logEvent(name: "DayCompleted");
        }
      }
    });
  }

  bool _chapterIsRead() {
    if (ReadingProgressProvider.instance.planProgress!.length >
        widget.readingDay) {
      return ReadingProgressProvider
          .instance.planProgress![widget.readingDay].egwReadingCompleted;
    }
    return false;
  }

  Widget _audioWidget() {
    return AudioDisplay(
      audios: [AudioProvider.shared.bookChapterAudio(widget.chapter!)],
      current: 0,
    );
  }

  List<TextSpan> splitSpan(
      TextSpan span, int start, int end, TextStyle mergeStyle) {
    start = max(0, start);
    end = min(end, span.text!.length);

    if (start >= span.text!.length) return [span];
    List<TextSpan> parts = [];

    if (start > 0) {
      parts.add(
          TextSpan(text: span.text!.substring(0, start), style: span.style));
    }
    parts.add(TextSpan(
        text: span.text!.substring(start, end),
        style: span.style?.merge(mergeStyle) ?? mergeStyle));
    if (end < span.text!.length) {
      parts.add(TextSpan(text: span.text!.substring(end), style: span.style));
    }

    return parts;
  }

  void editNote() async {
    if (lastSelection == null) return;
    var chapter = widget.chapter!;
    var selection = lastSelection!;
    final ChapterHighlights? highlights =
        NotesProvider.shared.get(chapter.book.shortName, chapter.number);

    if (highlights == null) return;
    TextMark? mark = highlights.marks.firstWhereIndexedOrNull(
        (index, element) =>
            element.start <= selection.start && element.end >= selection.start);

    if (mark == null) return;

    var text = await showBottomWidget(
      context: context,
      isScrollControlled: true,
      child: NoteWriterWidget(
        initialText: mark.note,
      ),
    );

    if (text == null) return;

    mark.note = text;

    NotesProvider.shared
        .save(chapter.book.name, chapter.book.shortName, highlights);
    setState(() {});
  }

  List<TextSpan> _lines(String text, int page) {
    var chapter = widget.chapter!;

    text = text.split("\n").map((a) => "    " + a.trim() + "\n").join();
    ChapterHighlights? highlights =
        HighlightsProvider.shared.get(chapter.book.shortName, chapter.number);
    ChapterHighlights? notes =
        NotesProvider.shared.get(chapter.book.shortName, chapter.number);

    List<TextSpan> result = [TextSpan(text: text)];

    List<TextMark> marks = [];

    if (highlights != null) {
      marks.addAll(highlights.marks.where((element) => element.page == page));
    }

    if (notes != null) {
      marks.addAll(notes.marks.where((element) => element.page == page));
    }

    if (marks.length == 0) return result;

    for (var mark in marks) {
      int position = 0;
      List<TextSpan> newList = [];
      TextStyle newStyle = mark.color != 0
          ? TextStyle(backgroundColor: Color(mark.color), color: Colors.black)
          : const TextStyle(
              decoration: TextDecoration.underline,
              decorationThickness: 2,
              decorationStyle: TextDecorationStyle.dashed,
            );

      for (var i = 0; i < result.length; i++) {
        if (position >= mark.end) {
          newList.addAll(result.skip(i));
          break;
        }

        var span = result[i];
        if (position + span.text!.length < mark.start) {
          newList.add(span);
        } else {
          newList.addAll(splitSpan(
              span, mark.start - position, mark.end - position, newStyle));
        }

        position += span.text!.length;
      }

      result = newList;
    }

    return result;
  }

  String? getSelectedReference() {
    final selection = lastSelection;
    if (selection == null ||
        selection.isCollapsed == true ||
        selection.isValid == false) {
      return null;
    }

    String chapName = widget.chapter!.book.name;
    if (widget.chapter!.number > 0) {
      chapName += ", ${localize("chapter")} ${widget.chapter!.number}";
    } else {
      chapName += ", ${widget.chapter!.title}";
    }

    return chapName;
  }

  void makeNote(String content, int page) async {
    var chapter = widget.chapter!;

    if (lastSelection == null ||
        lastSelection?.isCollapsed == true ||
        lastSelection?.isValid == false) {
      return;
    }
    var selection = lastSelection!;
    var text = await showBottomWidget(
        isScrollControlled: true,
        context: context,
        child: const NoteWriterWidget());
    if (text == null) return;

    ChapterHighlights highlights =
        NotesProvider.shared.get(chapter.book.shortName, chapter.number) ??
            ChapterHighlights(chapter: chapter.number, marks: []);

    var reference = getSelectedReference();
    content = content.split("\n").map((a) => "    " + a.trim() + "\n").join();
    var descrition = content
        .substring(lastSelection!.start, lastSelection!.end)
        .substringToWord(100);

    highlights.addMark(
      TextMark(
        color: 0,
        start: selection.start,
        end: selection.end,
        page: 0,
        day: widget.readingDay,
        reference: reference,
        description: descrition,
        note: text,
      ),
    );

    NotesProvider.shared
        .save(chapter.book.name, chapter.book.shortName, highlights);
    setState(() {});
  }

  void makeMark(Color? color, String text, int page) {
    var chapter = widget.chapter!;

    if (lastSelection == null ||
        lastSelection?.isCollapsed == true ||
        lastSelection?.isValid == false) {
      return;
    }
    ChapterHighlights highlights =
        HighlightsProvider.shared.get(chapter.book.shortName, chapter.number) ??
            ChapterHighlights(chapter: chapter.number, marks: []);

    var reference = getSelectedReference();

    text = text.split("\n").map((a) => "    " + a.trim() + "\n").join();

    var descrition = text
        .substring(lastSelection!.start, lastSelection!.end)
        .substringToWord(100);

    if (color == null) {
      highlights.removeMarks(lastSelection!.start, lastSelection!.end, page);
    } else {
      highlights.addMark(
        TextMark(
            color: color.value,
            start: lastSelection!.start,
            end: lastSelection!.end,
            page: page,
            day: widget.readingDay,
            reference: reference,
            description: descrition),
      );
    }
    HighlightsProvider.shared
        .save(chapter.book.name, chapter.book.shortName, highlights);
    setState(() {});
  }

  void share(String content) async {
    if (lastSelection == null ||
        lastSelection?.isCollapsed == true ||
        lastSelection?.isValid == false) {
      return;
    }
    var reference = getSelectedReference();
    content = content.split("\n").map((a) => "    " + a.trim() + "\n").join();
    var descrition =
        content.substring(lastSelection!.start, lastSelection!.end);
    var res = await showModalBottomSheet(
      backgroundColor: AppStyle.backgroundColor,
      context: context,
      builder: (builder) => const ShareOptionsModal(),
    );
    if (res == ShareOption.picture) {
      pushScreen(
          context, ShareScreen(text: descrition, reference: reference ?? ""));
    } else if (res == ShareOption.text) {
      SharePlus.instance
          .share(ShareParams(text: "$descrition ${reference ?? ""}"));
    }
  }

  Widget _page(BuildContext context, int page, String content) {
    String chapName = widget.chapter!.book.name;
    if (widget.chapter!.number > 0) {
      chapName += ", ${localize("chapter")} ${widget.chapter!.number}";
    }

    return SingleChildScrollView(
        dragStartBehavior: DragStartBehavior.start,
        controller: _textControllers[page].controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const VSpacer(16),
            if (page == 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Txt.b(widget.chapter!.title, size: 30),
                  const VSpacer(10),
                  Txt(chapName),
                  const VSpacer(20),
                  _audioWidget(),
                  const VSpacer(20),
                ],
              ),
            SelectableText.rich(
              TextSpan(
                children: _lines(content, page),
                style: SettingsProvider.instance.getReadingStyle(),
              ),
              selectionControls: SelectedTextMenu(
                colorSelected: (color) => makeMark(color, content, page),
                onNote: () => makeNote(content, page),
                onShare: () => share(content),
              ),
              onSelectionChanged: (selection, cause) {
                lastSelection = selection;
                if (selection.end == selection.start) editNote();
                if (!selection.isCollapsed) {
                  _textControllers[page].savePosition();
                }
              },
            ),
            Row(
              children: [
                if (page == _pages.length - 1)
                  DoneButton(
                      checked: _chapterIsRead(),
                      onPressed: () =>
                          _setChapterCompletion(!_chapterIsRead())),
                const Spacer(),
                Center(
                  child: Txt.b(
                    "${page + 1} / ${_pages.length}",
                    color: AppStyle.primaryColor,
                  ),
                ),
              ],
            ),
            const VSpacer(32),
            Row(children: <Widget>[
              if (page > 0)
                RoundedButton.secondary(
                    onPressed: () {
                      _pageController!.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    child: Txt(localize("before"))),
              const Spacer(),
              if (widget.showChangeContentButton && page == _pages.length - 1)
                RoundedButton(
                  onPressed: () {
                    widget.biblePressed?.call();
                  },
                  child: Txt(localize("go to bible")),
                ),
              if (page < _pages.length - 1)
                RoundedButton.secondary(
                  onPressed: () {
                    _pageController!.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  child: Txt(localize("next")),
                ),
            ]),
            const SafeArea(
                minimum: EdgeInsets.only(bottom: 20), child: VSpacer(16))
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
        controller: _pageController,
        children: _pages
            .asMap()
            .entries
            .map(
              (f) => _page(context, f.key, f.value),
            )
            .toList());
  }
}
