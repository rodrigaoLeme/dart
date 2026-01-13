import 'package:bibleplan/common.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BigPlayer extends StatefulWidget {
  const BigPlayer({Key? key}) : super(key: key);

  @override
  _BigPlayerState createState() => _BigPlayerState();
}

class _BigPlayerState extends State<BigPlayer> {
  bool _dragging = false;
  AudioInfo? _info;
  ValueNotifier<Duration> position = ValueNotifier(Duration.zero);

  @override
  void initState() {
    super.initState();
    _info = AudioManager.shared.currentAudio;
    _info?.addListener(_audioUpdated);
    AudioManager.shared.addListener(refresh);
    position.value = _info!.position ?? Duration.zero;
  }

  @override
  void dispose() {
    _info?.removeListener(_audioUpdated);
    AudioManager.shared.removeListener(refresh);
    //var d = 3;

    super.dispose();
  }

  void refresh() {
    if (_info != AudioManager.shared.currentAudio) {
      if (_info != null) {
        _info?.removeListener(_audioUpdated);
      }
      _info = AudioManager.shared.currentAudio;
      _info?.addListener(_audioUpdated);
      position.value = _info!.position ?? Duration.zero;
    }

    setState(() {});
  }

  void _audioUpdated() {
    if (!_dragging) position.value = _info!.position ?? Duration.zero;
    if (_info?.completed == true) popScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                color: AppStyle.primaryColor,
                onPressed: () {
                  popScreen(context);
                },
                icon: const Icon(FontAwesomeIcons.chevronDown)),
            const Spacer(),
            TextButton(
                onPressed: () {
                  AudioManager.shared.stop();
                },
                child: Txt.b(localize("End audio"), size: 16)),
            const HSpacer(16),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Txt(
            _info!.audio.title,
            size: 32,
            style: AppStyle.fancyFont,
            align: TextAlign.center,
          ),
        ),
        ValueListenableBuilder<Duration>(
          valueListenable: position,
          builder: (context, positionValue, child) {
            return Column(
              children: [
                if (_info!.duration.inSeconds > 0 && _info!.isReady) ...[
                  Slider(
                    activeColor: AppStyle.primaryColor,
                    inactiveColor: AppStyle.secondaryColor,
                    thumbColor: AppStyle.onSecondaryColor,
                    value: positionValue.inSeconds / _info!.duration.inSeconds,
                    onChangeStart: (value) {
                      _dragging = true;
                    },
                    onChanged: (value) {
                      position.value = _info!.duration * value;
                    },
                    onChangeEnd: (value) {
                      _dragging = false;
                      AudioManager.shared.seek(_info!.duration * value);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: Row(
                      children: [
                        Txt(_info!.timePosition),
                        const Spacer(),
                        Txt(_info!.duration.toTimeString()),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            alignment: AlignmentDirectional.center,
            clipBehavior: Clip.none,
            children: [
              AnimatedBuilder(
                  animation: _info!,
                  builder: (context, child) {
                    return _info!.isReady
                        ? CircularButton(
                            diameter: 64,
                            child: Icon(_info!.state == AudioState.playing
                                ? FontAwesomeIcons.pause
                                : FontAwesomeIcons.play),
                            onPressed: () {
                              _info!.state == AudioState.playing
                                  ? AudioManager.shared.pause()
                                  : AudioManager.shared.resume();
                            })
                        : const CircularProgressIndicator();
                  }),
              Positioned(
                top: 8,
                left: MediaQuery.of(context).size.width - 100,
                child: AnimatedBuilder(
                  animation: _info!,
                  builder: (context, child) {
                    return CircularButton.accent(
                      diameter: 60,
                      child: Txt(_info!.speed == AudioSpeed.normal
                          ? "1,0x"
                          : _info!.speed == AudioSpeed.midlle
                              ? "1,5x"
                              : "2,0x"),
                      onPressed: () {
                        _info!.speed == AudioSpeed.normal
                            ? AudioManager.shared.speed(AudioSpeed.midlle)
                            : _info!.speed == AudioSpeed.midlle
                                ? AudioManager.shared.speed(AudioSpeed.fast)
                                : AudioManager.shared.speed(AudioSpeed.normal);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
