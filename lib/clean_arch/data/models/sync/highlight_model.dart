import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/sync/sync.dart';

class HighlightModel {
  final String id;
  final int book;
  final int chapter;
  final int verse;
  final String color;
  final String? text;
  final DateTime createdAt;
  final String? deviceId;

  const HighlightModel({
    required this.id,
    required this.book,
    required this.chapter,
    required this.verse,
    required this.color,
    this.text,
    required this.createdAt,
    this.deviceId,
  });

  HighlightEntity toEntity() {
    return HighlightEntity(
      id: id,
      book: book,
      chapter: chapter,
      verse: verse,
      color: color,
      text: text,
      createdAt: createdAt,
      deviceId: deviceId,
    );
  }

  factory HighlightModel.fromEntity(HighlightEntity entity) {
    return HighlightModel(
      id: entity.id,
      book: entity.book,
      chapter: entity.chapter,
      verse: entity.verse,
      color: entity.color,
      text: entity.text,
      createdAt: entity.createdAt,
      deviceId: entity.deviceId,
    );
  }

  factory HighlightModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return HighlightModel(
      id: doc.id,
      book: data['book'] as int,
      chapter: data['chapter'] as int,
      verse: data['verse'] as int,
      color: data['color'] as String,
      text: data['text'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      deviceId: data['deviceId'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'book': book,
      'chapter': chapter,
      'verse': verse,
      'color': color,
      'text': text,
      'createdAt': Timestamp.fromDate(createdAt),
      'deviceId': deviceId,
    };
  }
}
