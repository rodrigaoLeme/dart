import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

extension CommaSeparatedStringExtension on String {
  String addCommaSeparatedItem(String newItem) {
    if (trim().isEmpty) return newItem;

    final items =
        split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    if (!items.contains(newItem)) {
      items.add(newItem);
    } else {
      items.remove(newItem);
    }
    items.sort();
    return items.join(',');
  }

  DateTime? get toEnDate {
    return DateTime.tryParse(this);
  }

  PlatformFile get fakePlatformFileFromPath {
    final file = File(this);
    final fileName = p.basename(this);
    final fileSize = file.existsSync() ? file.lengthSync() : 0;

    return PlatformFile(
      name: fileName,
      path: this,
      size: fileSize,
      bytes: null,
      readStream: file.openRead(),
    );
  }

  TimeOfDay? stringToTimeOfDay() {
    try {
      final parts = split(':');
      if (parts.length != 2) return null;
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }
}
