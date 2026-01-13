import 'package:bibleplan/common.dart';
import 'package:bibleplan/providers/language_provider.dart';
import 'package:bibleplan/shared/widgets/multi_section_selector.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({Key? key}) : super(key: key);

  @override
  _DownloadScreenState createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  ValueNotifier<int> audioGroup = ValueNotifier(0);

  Widget _cellContent(BuildContext context, AudioFile audio) {
    var icon = AudioManager.shared.currentAudio?.audio.key == audio.key
        ? AnimatedBuilder(
            animation: AudioManager.shared.currentAudio!,
            builder: (context, widget) {
              return Icon(
                AudioManager.shared.isPlaying(audio)
                    ? FontAwesomeIcons.pause
                    : FontAwesomeIcons.play,
                size: 16,
              );
            })
        : Icon(
            AudioManager.shared.isPlaying(audio)
                ? FontAwesomeIcons.pause
                : FontAwesomeIcons.play,
            size: 16,
          );

    return Cell(
      onPressed: () {
        AudioManager.shared.togglePlay(audio);
      },
      prefix: CircularButton(child: icon, onPressed: null),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 150,
                child: Txt.bsc(
                  audio.title,
                  13,
                  Colors.black,
                  overflow: TextOverflow.clip,
                  maxLines: 2,
                ),
              ),
              Txt("${AudioProvider.shared.audioFileSize(audio).toMB().toStringAsFixed(2)} Mb")
            ],
          ),
        ],
      ),
      accessory: IconButton(
        constraints: BoxConstraints.loose(const Size(40, 40)),
        padding: EdgeInsets.zero,
        onPressed: () {
          setState(() {
            AudioProvider.shared.deleteAudio(audio);
          });
        },
        icon: const Icon(Icons.delete),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Txt(localize("DOWNLOADS")),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: MultiSectionSelector(
              sections: [localize("Bible"), localize("Spirit of prophecy")],
              indexController: audioGroup,
            ),
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: audioGroup,
        builder: (context, value, child) {
          return AnimatedBuilder(
            animation: AudioManager.shared,
            builder: (context, child) {
              var type = AudioFileType.values[audioGroup.value];
              var audios = AudioProvider.shared.audios
                  .where((element) =>
                      element.type == type &&
                      (element.audioKey?.endsWith(Language.instance.current) ??
                          false ||
                              element.key.endsWith(Language.instance.current)))
                  .toList();

              // ignore: prefer_is_empty
              if (audios.length == 0) {
                return Center(
                  child: Txt(localize("No audio available")),
                );
              }

              return ListView.separated(
                itemBuilder: (context, index) =>
                    _cellContent(context, audios[index]),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: audios.length,
              );
            },
          );
        },
      ),
    );
  }
}
