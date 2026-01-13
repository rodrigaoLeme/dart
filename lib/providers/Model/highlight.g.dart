// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'highlight.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChapterHighlightsAdapter extends TypeAdapter<ChapterHighlights> {
  @override
  final int typeId = 1;

  @override
  ChapterHighlights read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChapterHighlights(
      chapter: fields[0] as int,
      marks: (fields[1] as List).cast<TextMark>(),
    );
  }

  @override
  void write(BinaryWriter writer, ChapterHighlights obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.chapter)
      ..writeByte(1)
      ..write(obj.marks);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChapterHighlightsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TextMarkAdapter extends TypeAdapter<TextMark> {
  @override
  final int typeId = 2;

  @override
  TextMark read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextMark(
      start: fields[0] as int,
      end: fields[1] as int,
      color: fields[2] as int,
      day: fields[7] as int,
      description: fields[3] as String?,
      reference: fields[4] as String?,
      date: fields[5] as DateTime?,
      note: fields[8] as String?,
      page: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TextMark obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.reference)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.page)
      ..writeByte(7)
      ..write(obj.day)
      ..writeByte(8)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextMarkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BooksHighlightsAdapter extends TypeAdapter<BooksHighlights> {
  @override
  final int typeId = 3;

  @override
  BooksHighlights read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BooksHighlights(
      name: fields[0] as String,
      key: fields[2] as String,
      chapters: (fields[1] as List).cast<ChapterHighlights>(),
    ).._chapters = (fields[3] as Map).cast<int, ChapterHighlights>();
  }

  @override
  void write(BinaryWriter writer, BooksHighlights obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.key)
      ..writeByte(3)
      ..write(obj._chapters)
      ..writeByte(1)
      ..write(obj.chapters);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BooksHighlightsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
