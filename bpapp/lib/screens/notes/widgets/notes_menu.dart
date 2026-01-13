import 'package:bibleplan/common.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum NotesMenuOption { open, delete, edit }

class NotesMenu extends StatelessWidget {
  final bool withEdit;

  const NotesMenu({Key? key, this.withEdit = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppStyle.defaultMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => popScreen(context),
          ),
          const VSpacer(10),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              style: TextButton.styleFrom(alignment: Alignment.centerLeft),
              onPressed: () => popScreen(context, result: NotesMenuOption.open),
              icon: const Icon(FontAwesomeIcons.bookOpen),
              label: Txt(localize("Open reference")),
            ),
          ),
          if (withEdit)
            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                onPressed: () =>
                    popScreen(context, result: NotesMenuOption.edit),
                icon: const Icon(FontAwesomeIcons.filePen),
                label: Txt(localize("Edit")),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              style: TextButton.styleFrom(alignment: Alignment.centerLeft),
              onPressed: () =>
                  popScreen(context, result: NotesMenuOption.delete),
              icon: const Icon(FontAwesomeIcons.trash),
              label: Txt(localize("Delete")),
            ),
          )
        ],
      ),
    );
  }
}
