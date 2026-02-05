class HighlightEntity {
  final String id;
  final int book;
  final int chapter;
  final int verse;
  final String color;
  final String? text;
  final DateTime createdAt;
  final String? deviceId;

  const HighlightEntity({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.color,
    this.text,
    required this.createdAt,
    this.deviceId,
  });

  HighlightEntity copyWith({
    String? id,
    int? book,
    int? chapter,
    int? verse,
    String? color,
    String? text,
    DateTime? createdAt,
    String? deviceId,
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
