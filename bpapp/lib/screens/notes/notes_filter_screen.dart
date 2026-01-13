import 'package:bibleplan/common.dart';
import 'package:bibleplan/providers/egw_books_provider.dart';
import 'package:bibleplan/shared/widgets/color_selection.dart';
import 'package:bibleplan/screens/notes/widgets/date_filter.dart';
import 'package:bibleplan/shared/widgets/multi_selection.dart';

class NotesFilter {
  Color? color;
  DateTime? from;
  DateTime? to;
  Set<String>? bibleBooks;
  Set<String>? egwBooks;

  NotesFilter({this.color, this.from, this.to, this.bibleBooks, this.egwBooks});
}

class NotesFilterScreen extends StatefulWidget {
  final NotesFilter? filter;

  const NotesFilterScreen({Key? key, this.filter}) : super(key: key);

  @override
  _NotesFilterScreenState createState() => _NotesFilterScreenState();
}

class _NotesFilterScreenState extends State<NotesFilterScreen> {
  Color? selectorColor;
  DateFilterController fromDateController = DateFilterController();
  DateFilterController toDateController = DateFilterController();
  MultiSelectionController bibleBooksController = MultiSelectionController();
  MultiSelectionController egwBooksController = MultiSelectionController();

  @override
  void initState() {
    super.initState();

    selectorColor = widget.filter?.color;
    fromDateController.value = widget.filter?.from;
    toDateController.value = widget.filter?.to;
    bibleBooksController.selection = widget.filter?.bibleBooks ?? {};
    egwBooksController.selection = widget.filter?.egwBooks ?? {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Txt(localize("FILTER")),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  selectorColor = null;
                  fromDateController.value = null;
                  toDateController.value = null;
                  bibleBooksController.selection.clear();
                  egwBooksController.selection.clear();
                });
              },
              child: Txt(localize("Clear")))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Txt.b(localize("Color"), size: 16),
            const VSpacer(16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: AppStyle.highlightColors
                  .map(
                    (e) => GestureDetector(
                      onTap: () => setState(() =>
                          selectorColor = (selectorColor != e ? e : null)),
                      child: ColorSelection(
                        color: e,
                        selected: e == selectorColor,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const VSpacer(16),
            Row(
              children: [
                Expanded(
                    child: DateFilter(
                        title: localize("From"),
                        controller: fromDateController)),
                const HSpacer(16),
                Expanded(
                    child: DateFilter(
                        title: localize("To"), controller: toDateController))
              ],
            ),
            const VSpacer(32),
            Txt.b(localize("Spirit of prophecy")),
            const VSpacer(8),
            MultiSelection(
                controller: egwBooksController,
                title: localize("Spirit of prophecy"),
                itens: {
                  for (var item in EGWBooksProvider.instance.codes())
                    item: EGWBooksProvider.instance.bookName(item)!
                }),
            const VSpacer(32),
            Txt.b(localize("Bible")),
            const VSpacer(8),
            MultiSelection(
                controller: bibleBooksController,
                title: localize("Bible"),
                itens: {
                  for (var item in BibleProvider.instance.bible!.books)
                    item!.shortName!: item.name!
                }),
            const VSpacer(32),
            Center(
              child: RoundedButton.text(
                localize("Save"),
                padding:
                    const EdgeInsets.symmetric(horizontal: 44, vertical: 8),
                onPressed: () {
                  var filter = NotesFilter(
                    color: selectorColor,
                    from: fromDateController.value,
                    to: toDateController.value,
                    bibleBooks: bibleBooksController.selection,
                    egwBooks: egwBooksController.selection,
                  );

                  popScreen(context, result: filter);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
