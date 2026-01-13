// ignore_for_file: prefer_final_fields

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bibleplan/common.dart';
import 'package:bibleplan/providers/settings_provider.dart';
import 'package:bibleplan/screens/share/widgets/color_collection.dart';
import 'package:bibleplan/screens/share/widgets/txt_canvas.dart';
import 'package:bibleplan/shared/widgets/font_selector.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareScreen extends StatefulWidget {
  final String text;
  final String reference;
  const ShareScreen({Key? key, required this.text, required this.reference})
      : super(key: key);

  @override
  _ShareScreenState createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  GlobalKey _globalKey = GlobalKey();
  int colorIndex = 3;
  String font = SettingsProvider.instance.fontName;

  Future<void> _capturePng() async {
    final RenderRepaintBoundary boundary =
        _globalKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage();
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();

    final temp = await getTemporaryDirectory();
    File tempImage = File(temp.path + "/tempimage.png");
    tempImage.writeAsBytesSync(pngBytes);
    //print(tempImage.path);

    final params = ShareParams(
      text: 'Great picture',
      files: [XFile(temp.path + "/tempimage.png")],
    );

    await SharePlus.instance.share(params);
  }

  void setColor(int index) => setState(() => colorIndex = index);

  void setFont(String font) => setState(() => this.font = font);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Txt(localize("SHARE")),
      ),
      bottomNavigationBar: Material(
        elevation: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const VSpacer(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Txt.b(localize("Choose a color"),
                  color: AppStyle.primaryColor, size: 16),
            ),
            const VSpacer(20),
            ColorCollection(colorSelected: colorIndex, onChange: setColor),
            const VSpacer(32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Txt.b(localize("Choose a font"),
                  color: AppStyle.primaryColor, size: 16),
            ),
            const VSpacer(20),
            FontSelector(font: font, onChange: setFont),
            const VSpacer(8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 44,
                child: RoundedButton(
                    onPressed: _capturePng, child: Txt(localize("SHARE"))),
              ),
            ),
            const VSpacer(16),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        color: const Color(0xFFEEEEEE),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TxtCanvas(
                  text: widget.text,
                  reference: widget.reference,
                  colorIndex: colorIndex,
                  font: font,
                  renderKey: _globalKey),
            ],
          ),
        ),
      ),
    );
  }
}
