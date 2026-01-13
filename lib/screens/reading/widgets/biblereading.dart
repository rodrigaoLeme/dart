// ignore_for_file: prefer_final_fields

import 'dart:math';

import 'package:bibleplan/common.dart';
import 'package:bibleplan/data/study_plan.dart';
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
import 'package:share_plus/share_plus.dart';

class BibleReading extends StatefulWidget {
  final List<BibleStudyReference>? chapters;
  final int readingDay;
  final bool showChangeContentButton;
  final Function()? esPressed;
  const BibleReading(this.chapters, this.readingDay,
      {this.esPressed, this.showChangeContentButton = true, Key? key})
      : super(key: key);

  @override
  _BibleReadingState createState() => _BibleReadingState();
}

class _BooksGroups {
  final BibleBook book;
  final List<BibleBookChapter?> chapters;
  _BooksGroups(this.book, this.chapters);
}

class _BibleReadingState extends State<BibleReading> {
  BibleBookChapter? _chapterSelected;

  late List<_BooksGroups> _groups;
  late List<_BooksGroups> _groupsToMarkDone;
  late List<BibleBookChapter> chapters;
  late List<String> verses;
  ScrollController _textScroll = ScrollController();
  TextSelection? lastSelection;
  double? lastX;

  String returnVerses(String book, String chapter, String ref, int verseIndex) {
    String r = "";
    List<String> arr = [];
    bool hasGap = (ref.contains(', ')) ? true : false;

    if (!hasGap) {
      var rr = ref.split(' ');
      if (rr[0] == "1" || rr[0] == "2" || rr[0] == "3") {
        r = rr[2];
      } else {
        r = rr[1];
      }
    } else {
      var rr1 = ref.split(' ');
      for (var rr in rr1) {
        if (rr == "1" || rr == "2" || rr == "3") {
          continue;
        } else {
          r = (r.isEmpty) ? rr : r + rr;
        }
      }
    }

    if (r.contains(';')) {
      var base = r.split(';');
      for (var x in base) {
        if (x.contains(':')) {
          arr.add(x);
        } else {
          if (x.contains('-')) {
            var numInicial = int.parse(x.split('-')[0]);
            var numFinal = int.parse(x.split('-')[1]);
            for (numInicial; numInicial <= numFinal; numInicial++) {
              arr.add(numInicial.toString());
            }
          } else {
            arr.add(x);
          }
        }
      }
      base.clear();
      base = arr;
      if (base[verseIndex].toString().contains(':')) {
        var base2 = base[verseIndex].split(':');
        if (base2[0] == chapter) {
          return "$book|$chapter*${base2[1]}";
        }
      } else {
        return "$book|$chapter*1-999";
      }
      return "$book|$chapter*1-999";
    } else {
      if (r.contains(':')) {
        var base = r.split(':');
        return "$book|$chapter*${base[1]}";
      } else {
        return "$book|$chapter*1-999";
      }
    }
  }

  void _onChapterSelected(BibleBookChapter chapter) {
    setState(() {
      _chapterSelected = chapter;
      _textScroll.jumpTo(0);
    });
  }

  @override
  void initState() {
    super.initState();

    chapters = [];
    verses = [];
    var index = -1;
    var increment = 0;
    var bible = BibleProvider.instance.bible;

    for (var f in widget.chapters!) {
      for (var p in f.chapters!) {
        index++;
        verses.add(returnVerses(
            f.book.toString(), p.toString(), f.reference.toString(), index));

        var originalChapter = bible!.books[f.book!]!.chapters![p - 1];
        var newChapter = BibleBookChapter(
          originalChapter.book,
          originalChapter.chapter,
          originalChapter.contentPosition,
        );

        var base = verses[increment].split('*')[1];
        if (base.contains(',')) {
          var baseArr = base.split(',');
          var base2a = baseArr[0].split('-');
          var base2b = baseArr[1].split('-');
          if (base2a.length > 1) {
            newChapter.initVerse = base2a[0];
            newChapter.finishVerse = base2a[1];
          }
          if (base2b.length > 1) {
            newChapter.secondInitVerse = base2b[0];
            newChapter.secondFinishVerse = base2b[1];
          }
        } else {
          var base2 = base.split('-');
          if (base2.length > 1) {
            newChapter.initVerse = base2[0];
            newChapter.finishVerse = base2[1];
          } else {
            newChapter.initVerse = base2[0];
            newChapter.finishVerse = base2[0];
          }
        }
        newChapter.isFullChapter = isFullChapter(newChapter.finishVerse);
        chapters.add(newChapter);
        increment++;
      }
    }

    _groupsToMarkDone = groupBy<BibleBookChapter?, String>(chapters, (f) {
      if (f!.isFullChapter == false) {
        return '${f.book.hashCode}_${f.hashCode}';
      } else {
        return '${f.book.hashCode}';
      }
    }).entries.map((f) => _BooksGroups(f.value.first!.book, f.value)).toList();

    _groups = groupBy<BibleBookChapter?, BibleBook>(chapters, (f) => f!.book)
        .entries
        .map((f) => _BooksGroups(f.key, f.value))
        .toList();

    _chapterSelected = chapters[0];
    _textScroll.addListener(scrollChanged);
    AudioManager.shared.addListener(audioChanged);
  }

  bool isFullChapter(String finalVerse) => (finalVerse == '999') ? true : false;

  @override
  void dispose() {
    _textScroll.removeListener(scrollChanged);
    AudioManager.shared.removeListener(audioChanged);
    super.dispose();
  }

  void audioChanged() {
    if (AudioManager.shared.currentAudio?.state == AudioState.playing) {
      var currentAudio = AudioManager.shared.currentAudio;
      if (currentAudio == null) return;

      var newChap = chapters
          .firstWhereOrNull((element) => element.id == currentAudio.audio.key);
      if (newChap != null && newChap != _chapterSelected) {
        setState(() {
          _chapterSelected = newChap;
        });
      }
    }
  }

  void scrollChanged() {
    if (lastX != null) {
      _textScroll.jumpTo(lastX!);
      lastX = null;
    }
  }

  bool _currentChapterCompleted() {
    var dayProgress = (widget.readingDay <
            ReadingProgressProvider.instance.planProgress!.length)
        ? ReadingProgressProvider.instance.planProgress![widget.readingDay]
        : ReadingProgressProvider.instance
            .planProgress![364]; // Ou algum valor padrão, se necessário
    for (var i = 0; i < _groupsToMarkDone.length; i++) {
      if (_groupsToMarkDone[i].book == _chapterSelected!.book) {
        for (var j = 0; j < _groupsToMarkDone[i].chapters.length; j++) {
          if (_groupsToMarkDone[i].chapters[j] == _chapterSelected) {
            if (dayProgress.bibleReading.length > i &&
                dayProgress.bibleReading[i].chapters!.length > j) {
              return dayProgress.bibleReading[i].chapters![j];
            }
          }
        }
      }
    }
    return false;
  }

  void completeCurrentChapter(bool complete, bool hasEGWBook) {
    setState(() {
      if (!hasEGWBook) {
        ReadingProgressProvider.instance.planProgress![widget.readingDay]
            .egwReadingCompleted = true;
      }
      var dayProgress =
          ReadingProgressProvider.instance.planProgress![widget.readingDay];
      for (var i = 0; i < _groupsToMarkDone.length; i++) {
        if (_groupsToMarkDone[i].book == _chapterSelected!.book) {
          for (var j = 0; j < _groupsToMarkDone[i].chapters.length; j++) {
            if (_groupsToMarkDone[i].chapters[j] == _chapterSelected) {
              if (dayProgress.bibleReading.length > i &&
                  dayProgress.bibleReading[i].chapters!.length > j) {
                dayProgress.bibleReading[i].chapters![j] = complete;
                ReadingProgressProvider.instance.saveProgress();

                if (ReadingProgressProvider
                    .instance.planProgress![widget.readingDay].isComplete) {
                  MyApp.analytics.logEvent(name: "DayCompleted");
                }

                return;
              }
            }
          }
        }
      }
    });
  }

  Widget _groupWidget(BuildContext context, _BooksGroups group) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: group.book == _chapterSelected!.book ? 1 : 0.7,
      child: Padding(
        padding: const EdgeInsets.only(right: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Txt.s(group.book.name!, 40, style: AppStyle.fancyFont),
            const VSpacer(10),
            Txt.sc(localize("chapters"), 12, const Color(0xFF707070)),
            const VSpacer(5),
            _chaptersList(context, group.chapters),
          ],
        ),
      ),
    );
  }

  Widget _chaptersList(BuildContext context, List<BibleBookChapter?> chapters) {
    BibleBook _lastBook = chapters.first!.book;
    return Row(
        children: chapters.map((f) {
      bool selected = f!.id == _chapterSelected!.id;
      bool withSpacing = _lastBook != f.book;
      _lastBook = f.book;
      return Container(
        margin: EdgeInsets.only(left: withSpacing ? 30 : 0),
        width: 60,
        height: 50,
        child: CircularButton(
            type: selected
                ? CircularButtonType.primary
                : CircularButtonType.accent,
            onPressed: () {
              _onChapterSelected(f);
            },
            child: Txt.s(
              f.chapter.toString(),
              f.chapter > 99 ? 16 : 20,
            )),
      );
    }).toList());
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

  List<TextSpan> _verses() {
    ChapterHighlights highlights = HighlightsProvider.shared.get(
            _chapterSelected!.book.shortName!, _chapterSelected!.chapter) ??
        ChapterHighlights(chapter: _chapterSelected!.chapter, marks: []);
    ChapterHighlights notes = NotesProvider.shared.get(
            _chapterSelected!.book.shortName!, _chapterSelected!.chapter) ??
        ChapterHighlights(chapter: _chapterSelected!.chapter, marks: []);

    List<TextSpan> result = [];
    for (var i = 0; i < _chapterSelected!.verses!.length; i++) {
      if (_chapterSelected!.secondInitVerse.isEmpty) {
        if (((i + 1 >= int.parse(_chapterSelected!.initVerse)) &&
            (i + 1 <= int.parse(_chapterSelected!.finishVerse)))) {
          result.add(TextSpan(
              text: "${i + 1}",
              style: const TextStyle(fontWeight: FontWeight.bold)));
          result.add(TextSpan(text: " ${_chapterSelected!.verses![i]}\n"));
        }
      } else {
        if (((i + 1 >= int.parse(_chapterSelected!.initVerse)) &&
                (i + 1 <= int.parse(_chapterSelected!.finishVerse))) ||
            ((i + 1 >= int.parse(_chapterSelected!.secondInitVerse)) &&
                (i + 1 <= int.parse(_chapterSelected!.secondFinishVerse)))) {
          result.add(TextSpan(
              text: "${i + 1}",
              style: const TextStyle(fontWeight: FontWeight.bold)));
          result.add(TextSpan(text: " ${_chapterSelected!.verses![i]}\n"));
        }
      }
    }

    var marks = [
      ...highlights.marks,
      ...notes.marks,
    ];

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

  Widget _audioWidget() {
    var allAudios =
        chapters.map(AudioProvider.shared.bibleChapterAudio).toList();
    var index =
        _chapterSelected != null ? chapters.indexOf(_chapterSelected!) : 0;

    return AudioDisplay(
      audios: allAudios,
      current: index,
    );
  }

  BibleReference? getSelectedReference([int? truncate = 100]) {
    final selection = lastSelection;
    if (selection == null ||
        selection.isCollapsed == true ||
        selection.isValid == false) {
      return null;
    }
    return _chapterSelected?.getReference(
        selection.start, selection.end, truncate);
  }

  void editNote() async {
    if (lastSelection == null) return;
    var selection = lastSelection!;
    final ChapterHighlights? highlights = NotesProvider.shared
        .get(_chapterSelected!.book.shortName!, _chapterSelected!.chapter);

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

    NotesProvider.shared.save(_chapterSelected!.book.name!,
        _chapterSelected!.book.shortName!, highlights);
    setState(() {});
  }

  void makeNote() async {
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

    ChapterHighlights highlights = NotesProvider.shared.get(
            _chapterSelected!.book.shortName!, _chapterSelected!.chapter) ??
        ChapterHighlights(chapter: _chapterSelected!.chapter, marks: []);

    int adjustedStartForHive = adjustCharacters(lastSelection!.start);
    int adjustedEndForHive = adjustCharacters(lastSelection!.end);

    var reference = _chapterSelected?.getReference(
        adjustedStartForHive, adjustedEndForHive);

    highlights.addMark(
      TextMark(
        color: 0,
        start: selection.start,
        end: selection.end,
        page: 0,
        day: widget.readingDay,
        reference: reference?.reference,
        description: reference?.text,
        note: text,
      ),
    );

    NotesProvider.shared.save(_chapterSelected!.book.name!,
        _chapterSelected!.book.shortName!, highlights);
    setState(() {});
  }

  int suppressedCharactersFunc() {
    // Calcula os caracteres suprimidos dos versículos anteriores
    int initVerse = int.parse(_chapterSelected!.initVerse);
    int suppressedCharacters = 0;

    // Contar os caracteres dos versículos anteriores ao initVerse
    for (int i = 0; i < initVerse - 1; i++) {
      suppressedCharacters += i.toString().length +
          _chapterSelected!.verses![i].length +
          2; // +1 para o espaço ou quebra de linha e
      // +1 para o espaço entre o número do versículo e o texto
    }

    return suppressedCharacters;
  }

  int adjustCharacters(int originalValue) {
    return suppressedCharactersFunc() + originalValue;
  }

  void makeMark(Color? color) {
    if (lastSelection == null ||
        lastSelection?.isCollapsed == true ||
        lastSelection?.isValid == false) {
      return;
    }

    ChapterHighlights highlights = HighlightsProvider.shared.get(
            _chapterSelected!.book.shortName!, _chapterSelected!.chapter) ??
        ChapterHighlights(chapter: _chapterSelected!.chapter, marks: []);

    int adjustedStartForHive = adjustCharacters(lastSelection!.start);
    int adjustedEndForHive = adjustCharacters(lastSelection!.end);

    var reference = _chapterSelected?.getReference(
        adjustedStartForHive, adjustedEndForHive);

    if (color == null) {
      highlights.removeMarks(lastSelection!.start, lastSelection!.end, 0);
    } else {
      highlights.addMark(
        TextMark(
          color: color.value,
          start: lastSelection!.start,
          end: lastSelection!.end,
          page: 0,
          day: widget.readingDay,
          reference: reference?.reference,
          description: reference?.text,
        ),
      );
    }

    HighlightsProvider.shared.save(_chapterSelected!.book.name!,
        _chapterSelected!.book.shortName!, highlights);
    setState(() {});
  }

  void share() async {
    if (lastSelection == null ||
        lastSelection?.isCollapsed == true ||
        lastSelection?.isValid == false) {
      return;
    }

    int adjustedStartForHive = adjustCharacters(lastSelection!.start);
    int adjustedEndForHive = adjustCharacters(lastSelection!.end);

    var reference = _chapterSelected?.getReference(
        adjustedStartForHive, adjustedEndForHive, null);

    var res = await showModalBottomSheet(
        backgroundColor: AppStyle.backgroundColor,
        context: context,
        builder: (builder) => const ShareOptionsModal());
    if (res == ShareOption.picture) {
      pushScreen(context,
          ShareScreen(text: reference!.text, reference: reference.reference));
    } else if (res == ShareOption.text) {
      SharePlus.instance.share(
          ShareParams(text: "${reference!.text} ${reference.reference}"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _textScroll,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const VSpacer(16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children:
                    _groups.map((f) => _groupWidget(context, f)).toList()),
          ),
          const VSpacer(20),
          _audioWidget(),
          const VSpacer(20),
          SelectableText.rich(
            TextSpan(
              children: _verses(),
              style: SettingsProvider.instance.getReadingStyle(),
            ),
            selectionControls: SelectedTextMenu(
                colorSelected: makeMark, onNote: makeNote, onShare: share),
            onSelectionChanged: (selection, cause) {
              lastSelection = selection;
              if (selection.end == selection.start) editNote();
              if (!selection.isCollapsed) lastX = _textScroll.offset;
            },
          ),
          const VSpacer(20),
          DoneButton(
              checked: _currentChapterCompleted(),
              onPressed: () => completeCurrentChapter(
                  !_currentChapterCompleted(), widget.showChangeContentButton)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: <Widget>[_chaptersList(context, chapters)],
            ),
          ),
          if (widget.showChangeContentButton &&
              _chapterSelected == chapters.last) ...[
            const VSpacer(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RoundedButton(
                  onPressed: () {
                    widget.esPressed?.call();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Txt(localize("read spirit of prophecy")),
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }
}
