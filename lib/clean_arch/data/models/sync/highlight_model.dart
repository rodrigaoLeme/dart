import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/sync/sync.dart';

class HighlightModel {
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

  const HighlightModel({
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
      language: language,
      start: start,
      end: end,
      reference: reference,
      page: page,
      day: day,
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
      language: entity.language,
      start: entity.start,
      end: entity.end,
      reference: entity.reference,
      page: entity.page,
      day: entity.day,
    );
  }

  factory HighlightModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return HighlightModel(
      id: doc.id,
      book: data['book'] as String,
      chapter: data['chapter'] as int,
      verse: data['verse'] as int,
      color: data['color'] as String,
      text: data['text'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      deviceId: data['deviceId'] as String?,
      language: data['language'] as String,
      start: data['start'] as int,
      end: data['end'] as int,
      reference: data['reference'] as String?,
      page: data['page'] as int,
      day: data['day'] as int,
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
      'language': language,
      'start': start,
      'end': end,
      'reference': reference,
      'page': page,
      'day': day,
    };
  }
}
