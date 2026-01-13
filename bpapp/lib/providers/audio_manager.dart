import 'dart:async';

import 'package:bibleplan/common.dart';
//import 'package:bibleplan/data/audio_file.dart';
import 'package:bibleplan/shared/player/audio_player.dart';
import 'package:bibleplan/shared/player/player_observer.dart';

enum AudioState {
  paused,
  loading,
  playing,
  error,
}

enum AudioSpeed {
  normal,
  midlle,
  fast,
}

class AudioInfo extends ChangeNotifier {
  bool _completed = false;
  Duration? _position;
  Duration _duration = Duration.zero;
  AudioState _state = AudioState.paused;
  AudioSpeed _speed = AudioSpeed.normal;

  final AudioFile audio;
  String? error;

  AudioState get state => _state;
  Duration? get position => _position;
  Duration get duration => _duration;
  bool get isReady =>
      _state == AudioState.paused || _state == AudioState.playing;
  bool get completed => _completed;
  String get timePosition => (_position ?? Duration.zero).toTimeString();
  AudioSpeed get speed => _speed;

  set state(AudioState value) {
    _state = value;
    notifyListeners();
  }

  set speed(AudioSpeed value) {
    _speed = value;
    notifyListeners();
  }

  set position(Duration? value) {
    _position = value;
    notifyListeners();
  }

  set duration(Duration value) {
    _duration = value;
    notifyListeners();
  }

  set completed(bool value) {
    _completed = value;
    notifyListeners();
  }

  AudioInfo(this.audio);
}

class AudioManager extends ChangeNotifier with PlayerObserver {
  static final AudioManager shared = AudioManager._();

  List<AudioInfo>? _playList;
  int _playlistIndex = 0;

  AudioPlayer player = AudioPlayer.instance()!;
  Duration? _lastDuration;

  AudioInfo? get currentAudio {
    if ((_playList?.length ?? 0) > _playlistIndex) {
      return _playList?[_playlistIndex];
    }
    return null;
  }

  AudioManager._();

  bool isPlaying(AudioFile audio) {
    if (currentAudio == null || currentAudio?.state != AudioState.playing) {
      return false;
    }
    return currentAudio?.audio.key == audio.key;
  }

  bool isLoading() {
    return currentAudio?.state == AudioState.loading ||
        (currentAudio != null && currentAudio?._position == null);
  }

  void playList(List<AudioFile> audios, {int startfrom = 0}) {
    _playList = audios.map((e) => AudioInfo(e)).toList();
    _playlistIndex = startfrom;

    _playCurrent();
  }

  void play(AudioFile audio) async {
    playList([audio]);
  }

  void _playCurrent({AudioSpeed speed = AudioSpeed.normal}) async {
    var current = currentAudio;
    var sp = 1.0;

    switch (speed) {
      case AudioSpeed.fast:
        sp = 2.0;
        break;
      case AudioSpeed.midlle:
        sp = 1.5;
        break;
      default:
        sp = 1.0;
    }

    if (current == null) return;

    var localPath = await AudioProvider.shared.audioPath(current.audio);

    if (currentAudio != null) {
      await player.reset();
    }

    current.state = AudioState.loading;

    await player.play(localPath ?? current.audio.url,
        title: current.audio.title, position: Duration.zero, speed: sp);

    notifyListeners();
  }

  void seek(Duration position) {
    if (currentAudio != null) player.seekTo(position.inSeconds.toDouble());
  }

  void speed(AudioSpeed speed) {
    if (currentAudio != null) {
      switch (speed) {
        case AudioSpeed.midlle:
          player.setSpeed(1.5);
          currentAudio!.speed = AudioSpeed.midlle;
          break;
        case AudioSpeed.fast:
          player.setSpeed(2.0);
          currentAudio!.speed = AudioSpeed.fast;
          break;
        default:
          player.setSpeed(1.0);
          currentAudio!.speed = AudioSpeed.normal;
      }
    }
  }

  Future resume() async {
    final info = currentAudio;
    if (info == null || info.state != AudioState.paused) return;
    var localPath = await AudioProvider.shared.audioPath(info.audio);
    player.play(localPath ?? info.audio.url,
        title: info.audio.title, position: info.position ?? Duration.zero);
  }

  void pause() {
    final info = currentAudio;
    if (info == null || info.state != AudioState.playing) return;
    player.pause();
  }

  void togglePlay(AudioFile file) {
    if (currentAudio?.audio.key != file.key) play(file);
    if (currentAudio?.state == AudioState.playing) pause();
    if (currentAudio?.state == AudioState.paused) resume();
  }

  void stop() {
    onComplete();
  }

  @override
  void onPlay() {
    currentAudio?.state = AudioState.playing;
    notifyListeners();
  }

  @override
  void onPause() {
    currentAudio?.state = AudioState.paused;
  }

  @override
  void onTime(int? position) {
    bool needNotification = currentAudio?.position == null;
    currentAudio?.position = Duration(seconds: position ?? 0);
    if (currentAudio?.duration.inMicroseconds == 0 && _lastDuration != null) {
      currentAudio?.duration = _lastDuration!;
    }
    if (needNotification) notifyListeners();
  }

  @override
  void onComplete() {
    currentAudio?.duration =
        (currentAudio?.position ?? currentAudio?.duration)!;
    if (_playlistIndex < (_playList?.length ?? 0) - 1) {
      var oldSpeed = currentAudio!.speed;
      _playlistIndex++;
      notifyListeners();
      _playCurrent(speed: oldSpeed);
      currentAudio!.speed = oldSpeed;
    } else {
      player.reset();
    }
  }

  @override
  void onDuration(int? duration) {
    currentAudio?.duration = Duration(milliseconds: duration ?? 0);
    _lastDuration = currentAudio!.duration;
  }

  @override
  void onError(String? error) {
    currentAudio
      ?..error = error
      ..state = AudioState.error;
  }
}
