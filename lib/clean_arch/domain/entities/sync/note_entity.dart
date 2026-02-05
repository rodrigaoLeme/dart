class NoteEntity {
  final String id;
  final int book;
  final int chapter;
  final int verse;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deviceId;

  const NoteEntity({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.deviceId,
  });

  NoteEntity copyWith({
    String? id,
    int? book,
    int? chapter,
    int? verse,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? deviceId,
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
