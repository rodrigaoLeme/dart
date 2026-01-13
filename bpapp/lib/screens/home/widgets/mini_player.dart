import 'package:bibleplan/common.dart';
import 'package:bibleplan/screens/home/widgets/big_player.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({Key? key}) : super(key: key);

  @override
  _MiniPlayerState createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer> {
  String timeStampForAudio(AudioInfo audio) {
    if (audio.duration.inSeconds > 0) {
      return "${audio.timePosition} / ${audio.duration.toTimeString()}";
    }
    return audio.timePosition;
  }

  Widget _audioStateAction(BuildContext context, AudioInfo audio) {
    if (audio.state == AudioState.loading) {
      return const Padding(
        padding: EdgeInsets.all(4.0),
        child:
            SizedBox.square(dimension: 20, child: CircularProgressIndicator()),
      );
    }
    if (audio.state == AudioState.error) {
      return const Icon(Icons.error);
    }

    return CircularButton(
      child: Icon(
          audio.state == AudioState.playing ? Icons.pause : Icons.play_arrow),
      onPressed: () {
        if (audio.state == AudioState.playing) {
          AudioManager.shared.pause();
        } else {
          AudioManager.shared.resume();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AudioManager.shared,
      builder: (context, child) {
        final AudioInfo? _currentAudio = AudioManager.shared.currentAudio;
        if (_currentAudio == null) return Container(height: 0);

        return InkWell(
          onTap: () {
            showBottomWidget(context: context, child: const BigPlayer());
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppStyle.defaultMargin,
                vertical: AppStyle.tinyMargin),
            color: AppStyle.primaryColor,
            child: SafeArea(
              child: AppTheme.surface(
                child: Row(
                  children: [
                    Expanded(
                        child:
                            Txt.bs(_currentAudio.audio.title, 18, maxLines: 2)),
                    const HSpacer(8),
                    AnimatedBuilder(
                      animation: _currentAudio,
                      builder: (context, child) {
                        return Row(
                          children: [
                            if (_currentAudio.state != AudioState.loading &&
                                _currentAudio.state != AudioState.error)
                              Txt(timeStampForAudio(_currentAudio)),
                            _audioStateAction(context, _currentAudio)
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
