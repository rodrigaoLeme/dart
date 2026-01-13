enum AudioFileType { bible, book }

class AudioFile {
  final String title;
  final String url;
  final String key;
  final String? subtitle;
  final String? audioKey;
  final AudioFileType type;

  AudioFile({
    required this.title,
    required this.url,
    required this.key,
    required this.type,
    this.audioKey,
    this.subtitle,
  });

  static AudioFile? fromJson(Map<String, dynamic> json) {
    String? title = json["title"];
    String? url = json["url"];
    String? key = json["key"];
    int? type = json["type"];
    if (title == null || url == null || key == null || type == null) {
      return null;
    }

    return AudioFile(
      key: key,
      title: title,
      url: url,
      subtitle: json["subtitle"],
      audioKey: json["audioKey"],
      type: AudioFileType.values[type],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "key": key,
      "url": url,
      "subtitle": subtitle,
      "audioKey": audioKey,
      "type": type.index,
    };
  }
}
