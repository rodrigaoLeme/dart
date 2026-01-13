import 'package:bibleplan/common.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AudioDisplay extends StatefulWidget {
  final List<AudioFile> audios;
  final int current;
  const AudioDisplay({Key? key, required this.audios, required this.current})
      : super(key: key);

  @override
  _AudioDisplayState createState() => _AudioDisplayState();
}

class _AudioDisplayState extends State<AudioDisplay> {
  @override
  void initState() {
    super.initState();
    AudioProvider.shared.addListener(_reset);
  }

  @override
  void dispose() {
    AudioProvider.shared.removeListener(_reset);
    super.dispose();
  }

  void _reset() {
    setState(() {});
  }

  void _playAudio() {
    AudioManager.shared.playList(widget.audios, startfrom: widget.current);
  }

  void _download() {
    AudioProvider.shared.download(widget.audios[widget.current]);
    setState(() {});
  }

  Widget _downloadWidget(AudioLocation location) {
    return location == AudioLocation.local
        ? const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(Icons.smartphone),
          )
        : location == AudioLocation.downloading
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                        color: AppStyle.primaryColor)),
              )
            : CircularButton.accent(
                child: const Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Icon(FontAwesomeIcons.download, size: 17),
                ),
                onPressed: _download);
  }

  Widget playButton(BuildContext context) {
    return RoundedButton.secondary(
      onPressed: !AudioManager.shared.isLoading() ? _playAudio : null,
      child: AudioManager.shared.isLoading()
          ? const SizedBox(
              child: CircularProgressIndicator(),
              height: 27,
              width: 27,
            )
          : Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: AppStyle.primaryColor,
                  ),
                  padding: const EdgeInsets.only(
                      left: 10, top: 8, right: 8, bottom: 8),
                  child: Icon(FontAwesomeIcons.play,
                      color: AppStyle.onPrimaryColor, size: 14),
                ),
                const HSpacer(8),
                Txt(localize("Listen"), size: 16),
                const HSpacer(4),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AudioLocation>(
      future:
          AudioProvider.shared.getAudioLocation(widget.audios[widget.current]),
      builder: (context, value) {
        return !value.hasData || value.data == AudioLocation.none
            ? Container()
            : Row(
                children: [
                  AnimatedBuilder(
                    animation: AudioManager.shared,
                    builder: (context, child) => playButton(context),
                  ),
                  const HSpacer(8),
                  _downloadWidget(value.data!)
                ],
              );
      },
    );
  }
}
