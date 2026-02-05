class NoteEntity {
  final String id;
  final String book;
  final int chapter;
  final int verse;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deviceId;
  final String language;
  final int start;
  final int end;
  final String? textSnippet;
  final String? reference;
  final int page;
  final int day;

  const NoteEntity({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.deviceId,
    required this.language,
    required this.start,
    required this.end,
    this.textSnippet,
    this.reference,
    required this.page,
    required this.day,
  });

  NoteEntity copyWith({
    String? id,
    String? book,
    int? chapter,
    int? verse,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deviceId,
    String? language,
    int? start,
    int? end,
    String? textSnippet,
    String? reference,
    int? page,
    int? day,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      book: book ?? this.book,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      language: language ?? this.language,
      start: start ?? this.start,
      end: end ?? this.end,
      textSnippet: textSnippet ?? this.textSnippet,
      reference: reference ?? this.reference,
      page: page ?? this.page,
      day: day ?? this.day,
    );
  }

  String get uniqueKey => '$book:$chapter:$verse';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NoteEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
