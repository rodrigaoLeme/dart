import 'package:bibleplan/common.dart';

class DateFilterController extends ValueNotifier<DateTime?> {
  DateFilterController() : super(null);
}

class DateFilter extends StatefulWidget {
  final String title;
  final DateFilterController controller;

  const DateFilter({Key? key, required this.title, required this.controller})
      : super(key: key);

  @override
  _DateFilterState createState() => _DateFilterState();
}

class _DateFilterState extends State<DateFilter> {
  String dateToString(DateTime datetime) {
    return "${datetime.day.zeroPadded(2)}/${datetime.month.zeroPadded(2)}/${datetime.year}";
  }

  String buttonTitle() {
    return widget.controller.value == null
        ? localize("Choose Date")
        : dateToString(widget.controller.value!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Txt.b(widget.title, size: 16),
        const VSpacer(8),
        GestureDetector(
          onTap: () async {
            DateTime? date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            widget.controller.value = date;
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppStyle.secondaryColor,
              borderRadius: BorderRadius.circular(22),
            ),
            child: InkWell(
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: widget.controller,
                  builder: (context, value, child) =>
                      Txt(buttonTitle(), size: 16),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
