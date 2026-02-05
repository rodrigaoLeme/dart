class HighlightEntity {
  final String id;
  final String book;
  final int chapter;
  final int verse;
  final String color;
  final String? text;
  final DateTime createdAt;
  final String? deviceId;
  final String language;
  final int start;
  final int end;
  final String? reference;
  final int page;
  final int day;

  const HighlightEntity({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.color,
    this.text,
    required this.createdAt,
    this.deviceId,
    required this.language,
    required this.start,
    required this.end,
    this.reference,
    required this.page,
    required this.day,
  });

  HighlightEntity copyWith({
    String? id,
    String? book,
    int? chapter,
    int? verse,
    String? color,
    String? text,
    DateTime? createdAt,
    String? deviceId,
    String? language,
    int? start,
    int? end,
    String? reference,
    int? page,
    int? day,
  }) {
    return HighlightEntity(
      id: id ?? this.id,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      color: color ?? this.color,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      deviceId: deviceId ?? this.deviceId,
      language: language ?? this.language,
      start: start ?? this.start,
      end: end ?? this.end,
      reference: reference ?? this.reference,
      page: page ?? this.page,
      day: day ?? this.day,
    );
  }

  String get uniqueKey => '$book:$chapter:$verse';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HighlightEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
