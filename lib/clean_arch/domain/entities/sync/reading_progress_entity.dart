class ReadingProgressEntity {
  final List<DayProgressEntity> days;
  final DateTime? lastUpdated;
  final String? deviceId;

  const ReadingProgressEntity({
    required this.days,
    this.lastUpdated,
    this.deviceId,
  });

  factory ReadingProgressEntity.empty({bool isLeapYear = false}) {
    final totalDays = isLeapYear ? 365 : 366;
    return ReadingProgressEntity(
      days: List.generate(totalDays, (_) => const DayProgressEntity.empty()),
      lastUpdated: DateTime.now(),
    );
  }

  bool get isLeapYer => days.length == 366;

  // Para ano bissexto (dia 366), retorna o mesmo progresso do dia 365
  DayProgressEntity getDay(int dayIndex) {
    if (dayIndex < 0 || dayIndex >= days.length) {
      throw RangeError('Day index must be between 0 and ${days.length - 1}');
    }

    if (dayIndex == 365 && days.length == 365) {
      return days[364]; // Não confunde, hein?! é o index!
    }

    return days[dayIndex];
  }

  ReadingProgressEntity updateDay(int dayIndex, DayProgressEntity progress) {
    if (dayIndex < 0 || dayIndex > 365) {
      throw RangeError('Day index must be between 0 and 365');
    }

    final targetIndex =
        (dayIndex == 365 && days.length == 365) ? 364 : dayIndex;

    final updatedDays = List<DayProgressEntity>.from(days);
    updatedDays[targetIndex] = progress;

    return copyWith(
      days: updatedDays,
      lastUpdated: DateTime.now(),
    );
  }

  ReadingProgressEntity copyWith({
    List<DayProgressEntity>? days,
    DateTime? lastUpdated,
    String? deviceId,
  }) {
    return ReadingProgressEntity(
      days: days ?? this.days,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}

class DayProgressEntity {
  final bool? complete;
  final List<int>? books;
  final bool? egwReadingCompleted;
  final List<List<bool>>? bibleReading;

  const DayProgressEntity({
    this.complete,
    this.books,
    this.egwReadingCompleted,
    this.bibleReading,
  });

  const DayProgressEntity.empty()
      : complete = null,
        books = null,
        egwReadingCompleted = false,
        bibleReading = null;

  bool get isComplete {
    if (complete != null) return complete!;

    final bibleComplete =
        bibleReading?.every((group) => group.every((chapter) => chapter)) ??
            false;

    return bibleComplete && (egwReadingCompleted ?? false);
  }

  DayProgressEntity copyWith({
    bool? complete,
    List<int>? books,
    bool? egwReadingCompleted,
    List<List<bool>>? bibleReading,
  }) {
    return DayProgressEntity(
      complete: complete ?? this.complete,
      books: books ?? this.books,
      egwReadingCompleted: egwReadingCompleted ?? this.egwReadingCompleted,
      bibleReading: bibleReading ?? this.bibleReading,
    );
  }
}
