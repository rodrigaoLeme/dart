import 'package:bibleplan/common.dart';

class MultiSelectionController {
  Set<String> selection = {};
}

class MultiSelection extends StatefulWidget {
  final Map<String, String> itens;
  final String? title;
  final MultiSelectionController controller;

  const MultiSelection(
      {Key? key, required this.itens, required this.controller, this.title})
      : super(key: key);

  @override
  _MultiSelectionState createState() => _MultiSelectionState();
}

class _MultiSelectionState extends State<MultiSelection> {
  String description() {
    var result = widget.controller.selection
        .take(2)
        .map((e) => widget.itens[e])
        .join(", ");
    if (widget.controller.selection.length > 2) {
      result += ", +${widget.controller.selection.length - 2}";
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppStyle.secondaryColor),
        ),
        height: 44,
        child: Row(
          children: [
            Expanded(child: Txt(description())),
            const Icon(Icons.arrow_drop_down)
          ],
        ),
      ),
      onTap: () async {
        await pushScreen(
          context,
          _MultiSelectionScreen(
              itens: widget.itens,
              selection: widget.controller.selection,
              title: widget.title ?? ""),
        );
        setState(() {});
      },
    );
  }
}

class _MultiSelectionScreen extends StatefulWidget {
  final Map<String, String> itens;
  final Set<String> selection;
  final String title;

  const _MultiSelectionScreen(
      {Key? key,
      required this.title,
      required this.itens,
      required this.selection})
      : super(key: key);

  @override
  __MultiSelectionScreenState createState() => __MultiSelectionScreenState();
}

class __MultiSelectionScreenState extends State<_MultiSelectionScreen> {
  List<String> _keys = [];

  @override
  void initState() {
    super.initState();
    _keys = widget.itens.keys.toList();
  }

  void toggle(String key) {
    if (widget.selection.contains(key)) {
      widget.selection.remove(key);
    } else {
      widget.selection.add(key);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Txt(widget.title),
        actions: [
          TextButton(
            onPressed: () => setState(() => widget.selection.clear()),
            child: Txt(localize("Clear")),
          ),
        ],
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => Cell(
                onPressed: () => setState(() => toggle(_keys[index])),
                child: Txt(widget.itens[_keys[index]] ?? ""),
                accessory: Checkbox(
                  value: widget.selection.contains(_keys[index]),
                  onChanged: (value) => setState(() => toggle(_keys[index])),
                ),
              ),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: widget.itens.length),
    );
  }
}
