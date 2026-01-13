import 'package:bibleplan/common.dart';

enum ShareOption { text, picture }

class ShareOptionsModal extends StatelessWidget {
  const ShareOptionsModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(children: [
        const VSpacer(8),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppStyle.defaultMargin),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: IconButton(
                  color: AppStyle.primaryColor,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    popScreen(context);
                  },
                ),
              ),
              const Spacer(),
              Txt.bs(localize("SHARE").toUpperCase(), 16,
                  color: AppStyle.primaryColor),
              const Spacer(),
              const SizedBox(width: 30)
            ],
          ),
        ),
        const VSpacer(20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                CircularButton(
                  diameter: 50,
                  onPressed: () =>
                      popScreen(context, result: ShareOption.picture),
                  child: const Icon(Icons.image),
                ),
                const VSpacer(10),
                Txt(localize("Image")),
              ],
            ),
            const HSpacer(30),
            Column(
              children: [
                CircularButton(
                  diameter: 50,
                  onPressed: () => popScreen(context, result: ShareOption.text),
                  child: const Icon(Icons.text_fields),
                ),
                const VSpacer(10),
                Txt(localize("Text")),
              ],
            ),
          ],
        )
      ]),
    );
  }
}
