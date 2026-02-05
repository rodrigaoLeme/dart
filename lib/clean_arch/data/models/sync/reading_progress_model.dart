import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/sync/sync.dart';

class ReadingProgressModel {
  final List<DayProgressModel> days;
  final DateTime? lastUpdated;
  final String? deviceId;

  const ReadingProgressModel({
    required this.days,
    this.lastUpdated,
    this.deviceId,
  });

  /// Converte Model -> Entity
  ReadingProgressEntity toEntity() {
    return ReadingProgressEntity(
      days: days.map((day) => day.toEntity()).toList(),
      lastUpdated: lastUpdated,
      deviceId: deviceId,
    );
  }

  /// Converte Entity -> Model
  factory ReadingProgressModel.fromEntity(ReadingProgressEntity entity) {
    return ReadingProgressModel(
      days: entity.days.map((day) => DayProgressModel.fromEntity(day)).toList(),
      lastUpdated: entity.lastUpdated,
      deviceId: entity.deviceId,
    );
  }

  /// Converte Firestore -> Model
  factory ReadingProgressModel.fromFirestore(Map<String, dynamic> data) {
    return ReadingProgressModel(
      days: (data['days'] as List<dynamic>)
          .map((day) => DayProgressModel.fromJson(day as Map<String, dynamic>))
          .toList(),
      lastUpdated: (data['LastUpdated'] as Timestamp?)?.toDate(),
      deviceId: data['deviceId'] as String?,
    );
  }

  /// COnverte Model -> Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'days': days.map((day) => day.toJson()).toList(),
      'lastUpdated': (lastUpdated != null)
          ? Timestamp.fromDate(lastUpdated!)
          : FieldValue.serverTimestamp(),
      'deviceId': deviceId,
    };
  }

  /// Converte JSON local (.pgs) -> Model
  factory ReadingProgressModel.fromLocalJson(List<dynamic> jsonList) {
    return ReadingProgressModel(
      days: jsonList
          .map((day) => DayProgressModel.fromJson(day as Map<String, dynamic>))
          .toList(),
      lastUpdated: DateTime.now(),
    );
  }

  /// Converte Model -> JSON local (.pgs)
  List<Map<String, dynamic>> toLocalJson() {
    return days.map((day) => day.toJson()).toList();
  }
}

class DayProgressModel {
  final bool? complete;
  final List<int>? books;
  final bool? egwReadingCompleted;
  final List<List<bool>>? bibleReading;

  const DayProgressModel({
    this.complete,
    this.books,
    this.egwReadingCompleted,
    this.bibleReading,
  });

  DayProgressEntity toEntity() {
    return DayProgressEntity(
      complete: complete,
      books: books,
      egwReadingCompleted: egwReadingCompleted,
      bibleReading: bibleReading,
    );
  }

  factory DayProgressModel.fromEntity(DayProgressEntity entity) {
    return DayProgressModel(
      complete: entity.complete,
      books: entity.books,
      egwReadingCompleted: entity.egwReadingCompleted,
      bibleReading: entity.bibleReading,
    );
  }

  factory DayProgressModel.fromJson(Map<String, dynamic> json) {
    return DayProgressModel(
      complete: json['complete'] as bool?,
      books: (json['books'] as List<dynamic>?)?.cast<int>(),
      egwReadingCompleted: json['egwReadingCompleted'] as bool?,
      bibleReading: (json['bibleReading'] as List<dynamic>?)
          ?.map((group) => (group as List<dynamic>).cast<bool>())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (complete != null) json['complete'] = complete;
    if (books != null) json['books'] = books;
    if (egwReadingCompleted != null) {
      json['egwReadingCompleted'] = egwReadingCompleted;
    }
    if (bibleReading != null) json['bibleReading'] = bibleReading;

    return json;
  }
}
