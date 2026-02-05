import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/sync/sync.dart';

class NoteModel {
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

  const NoteModel({
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

  NoteEntity toEntity() {
    return NoteEntity(
      id: id,
      book: book,
      chapter: chapter,
      verse: verse,
      content: content,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deviceId: deviceId,
      language: language,
      start: start,
      end: end,
      textSnippet: textSnippet,
      reference: reference,
      page: page,
      day: day,
    );
  }

  factory NoteModel.fromEntity(NoteEntity entity) {
    return NoteModel(
      id: entity.id,
      book: entity.book,
      chapter: entity.chapter,
      verse: entity.verse,
      content: entity.content,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      deviceId: entity.deviceId,
      language: entity.language,
      start: entity.start,
      end: entity.end,
      textSnippet: entity.textSnippet,
      reference: entity.reference,
      page: entity.page,
      day: entity.day,
    );
  }

  factory NoteModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return NoteModel(
      id: doc.id,
      book: data['book'] as String,
      chapter: data['chapter'] as int,
      verse: data['verse'] as int,
      content: data['content'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      deviceId: data['deviceId'] as String?,
      language: data['language'] as String,
      start: data['start'] as int,
      end: data['end'] as int,
      textSnippet: data['textSnippet'] as String?,
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
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'deviceId': deviceId,
      'language': language,
      'start': start,
      'end': end,
      'textSnippet': textSnippet,
      'reference': reference,
      'page': page,
      'day': day,
    };
  }
}
