// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:io';

import 'package:bibleplan/common.dart';
//import 'package:bibleplan/data/audio_file.dart';
import 'package:bibleplan/data/book.dart';
import 'package:bibleplan/providers/egw_books_provider.dart';
import 'package:bibleplan/providers/language_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

enum AudioLocation { none, remote, downloading, local }

class AudioProvider extends ChangeNotifier {
  static AudioProvider shared = AudioProvider._();
  List<AudioFile> _audios = [];
  Set<String> _availabilityCache = {};
  Set<String> _downlaoding = {};
  late Directory _directory;

  AudioProvider._();

  Future init() async {
    _directory = await getApplicationDocumentsDirectory();
    await _loadAudios();
  }

  List<AudioFile> get audios => List.from(_audios);

  AudioFile bibleChapterAudio(BibleBookChapter chapter) {
    var fileMp3 = "";

    if (chapter.finishVerse == '999') {
      fileMp3 = "${chapter.chapter.zeroPadded(3)}.mp3";
    } else {
      fileMp3 =
          "${chapter.chapter}_${chapter.initVerse}-${chapter.finishVerse}.mp3";
    }
    return AudioFile(
        key: chapter.id,
        audioKey:
            "${(chapter.book.number! + 1).zeroPadded(2)}_${chapter.chapter.zeroPadded(3)}_${Language.instance.current}",
        title: "${chapter.book.name} ${chapter.chapter}",
        type: AudioFileType.bible,
        url:
            "https://cdn.centrowhite.org.br/bibleplan/biblia-${Language.instance.current}/${(chapter.book.number! + 1).zeroPadded(2)}/$fileMp3");
  }

  AudioFile bookChapterAudio(BookChapter chapter) {
    var shortName = EGWBooksProvider.instance.bookCode(chapter.book);
    return AudioFile(
      key:
          "${chapter.book.shortName}-${chapter.number}-${Language.instance.current}",
      audioKey:
          "${chapter.book.shortName}-${chapter.number}-${Language.instance.current}",
      title: "${chapter.book.name} ${chapter.number}",
      subtitle: chapter.title,
      type: AudioFileType.book,
      url:
          "https://cdn.centrowhite.org.br/bibleplan/egw-${Language.instance.current}/$shortName/$shortName-${chapter.number.zeroPadded(2)}.mp3",
    );
  }

  Future<bool> audioFileExists(AudioFile file) async {
    if (_availabilityCache.contains(file.url)) return true;

    var response = await http.head(Uri.parse(file.url));
    if (response.statusCode == 200) _availabilityCache.add(file.url);

    return response.statusCode == 200;
  }

  int audioFileSize(AudioFile file) {
    try {
      var localFile = File(_directory.path + "/${file.audioKey}.mp3");
      return localFile.lengthSync();
      // ignore: empty_catches
    } catch (ex) {}
    return 0;
  }

  Future<bool> hasAudio(AudioFile file) async {
    var localFile = File(_directory.path + "/${file.audioKey}.mp3");
    return await localFile.exists();
  }

  Future<String?> audioPath(AudioFile file) async {
    var localFile = File(_directory.path + "/${file.audioKey}.mp3");
    if (await localFile.exists()) return "file://" + localFile.path;
    return null;
  }

  Future<AudioLocation> getAudioLocation(AudioFile file) async {
    if (_downlaoding.contains(file.url)) return AudioLocation.downloading;
    if (await hasAudio(file)) return AudioLocation.local;
    if (await audioFileExists(file)) return AudioLocation.remote;
    return AudioLocation.none;
  }

  Future download(AudioFile file) async {
    if (_downlaoding.contains(file.url)) return;
    _downlaoding.add(file.url);
    notifyListeners();
    var localFile = File(_directory.path + "/${file.audioKey}.mp3");

    var client = http.Client();
    var d = http.Request("GET", Uri.parse(file.url));
    var z = await client.send(d);
    await z.stream.pipe(localFile.openWrite());

    client.close();
    _downlaoding.remove(file.url);

    _audios.add(file);
    await _saveAudios();
    notifyListeners();
  }

  void deleteAudio(AudioFile file) {
    _audios.remove(file);
    var localFile = File(_directory.path + "/${file.audioKey}.mp3");
    if (localFile.existsSync()) localFile.deleteSync();
  }

  Future _saveAudios() async {
    var json = jsonEncode(_audios);
    var localFile = File(_directory.path + "/downloads.json");
    await localFile.writeAsString(json);
  }

  Future _loadAudios() async {
    var localFile = File(_directory.path + "/downloads.json");
    if (!(await localFile.exists())) return;

    var json = await localFile.readAsString();
    var list = jsonDecode(json) as List;

    _audios = list
        .map((e) => AudioFile.fromJson(e))
        .where((element) => element != null)
        .map((e) => e!)
        .toList();
  }
}
