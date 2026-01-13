// ignore_for_file: prefer_final_fields

import 'package:bibleplan/common.dart';

class NoteWriterWidget extends StatefulWidget {
  final String? initialText;

  const NoteWriterWidget({Key? key, this.initialText}) : super(key: key);

  @override
  _NoteWriterWidgetState createState() => _NoteWriterWidgetState();
}

class _NoteWriterWidgetState extends State<NoteWriterWidget> {
  TextEditingController? _controller = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _controller?.text = widget.initialText ?? "";
  }

  void _save() {
    popScreen(context, result: _controller?.text ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const VSpacer(8),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppStyle.defaultMargin),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: AppStyle.primaryColor,
                  onPressed: () {
                    popScreen(context);
                  },
                ),
              ),
              const Spacer(),
              Txt.bs(localize("NOTE").toUpperCase(), 16,
                  color: AppStyle.primaryColor),
              const Spacer(),
              const SizedBox(width: 30)
            ],
          ),
        ),
        const VSpacer(10),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 200,
            child: TextField(
              style: TextStyle(color: AppStyle.onBackgroundColor),
              controller: _controller,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: AppStyle.onBackgroundColor.withValues(alpha: 0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 1,
                    color: AppStyle.onBackgroundColor.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: AppStyle.primaryColor,
                  ),
                ),
              ),
              maxLines: null,
              minLines: null,
              expands: true,
            ),
          ),
        ),
        const VSpacer(20),
        RoundedButton(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 10),
          child: Txt(localize("save note")),
          onPressed: _save,
        )
      ],
    );
  }
}
