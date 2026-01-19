import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension HumanDateTime on DateTime {
  static String humanDate({required DateTime dateTime}) {
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day/$month/$year às $hour:$minute';
  }
}

extension DateTimeYearMonthDay on DateTime {
  static String yearMonthDay({required DateTime dateTime}) {
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();

    return '$year/$month/$day/';
  }
}

extension DateTimeDayMonthYear on DateTime {
  static String dayMontYear({required DateTime dateTime}) {
    String day = dateTime.day.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String year = dateTime.year.toString();

    return '$day/$month/$year';
  }
}

extension DateTimeEn on DateTime {
  String get dayToStringEn {
    String day = (this.day < 10) ? '0${this.day}' : this.day.toString();
    String month = (this.month < 10) ? '0${this.month}' : '${this.month}';
    String year = '${this.year}';
    return '$year-$month-$day';
  }

  String get dayMonthYear {
    String day = (this.day < 10) ? '0${this.day}' : this.day.toString();
    String month = (this.month < 10) ? '0${this.month}' : '${this.month}';
    String year = '${this.year}';
    return '$day/$month/$year';
  }

  String get dayMonth {
    String day = (this.day < 10) ? '0${this.day}' : this.day.toString();
    String month = (this.month < 10) ? '0${this.month}' : '${this.month}';
    return '$day/$month';
  }
}

extension DateTimeWithHour on DateTime {
  String get dateWithHour {
    var day = this.day;
    var month = this.month.toMonthName();
    var hour = this.hour;
    return 'Data $day de $month às ${hour.toString().padLeft(2, '0')}h';
  }

  String get completeDate {
    var day = this.day;
    var month = this.month.toMonthName();
    var year = this.year;

    return '$day de $month $year';
  }

  String get timeAgo {
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());
    timeago.setLocaleMessages('pt_BR_short', timeago.PtBrShortMessages());
    final now = DateTime.now();
    final difference = now.difference(this);
    return timeago.format(DateTime.now().subtract(difference), locale: 'pt_BR');
  }

  String get completeDatewithHour {
    var day = this.day;
    var month = this.month.toMonthName();

    var hour = this.hour;
    var minute = this.minute;

    if (day < 10) {
      return '0$day/$month às ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    }

    return '$day/$month às ${hour.toString().padLeft(2, '0')}h';
  }

  String get completeHour {
    var hour = this.hour;
    var minute = this.minute;

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

extension DateTimeFormatting on DateTime {
  String format() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays == 0) {
      return 'Hoje';
    } else if (difference.inDays == 1) {
      return 'Ontem';
    } else if (difference.inDays == 2) {
      return 'Anteontem';
    } else {
      return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}';
    }
  }
}

extension MonthName on DateTime {
  String get monthNameShort {
    switch (month) {
      case DateTime.january:
        return 'Jan';
      case DateTime.february:
        return 'Feb';
      case DateTime.march:
        return 'Mar';
      case DateTime.april:
        return 'Apr';
      case DateTime.may:
        return 'May';
      case DateTime.june:
        return 'Jun';
      case DateTime.july:
        return 'Jul';
      case DateTime.august:
        return 'Ago';
      case DateTime.september:
        return 'Sep';
      case DateTime.october:
        return 'Oct';
      case DateTime.november:
        return 'Nov';
      case DateTime.december:
        return 'Dec';
    }
    return '';
  }
}

extension WeekName on DateTime {
  String get weekDayName {
    switch (weekday) {
      case DateTime.sunday:
        return 'DOM';
      case DateTime.monday:
        return 'SEG';
      case DateTime.thursday:
        return 'TER';
      case DateTime.tuesday:
        return 'QUA';
      case DateTime.wednesday:
        return 'QUI';
      case DateTime.friday:
        return 'SEX';
      case DateTime.saturday:
        return 'SÁB';
    }
    return '';
  }
}

extension MonthWIthYearName on DateTime {
  String get dateWithMonthYear {
    var month = this.month.toMonthName(shortName: true);
    var year = this.year;
    return ' $month/$year';
  }
}

extension MonthToNumber on String {
  int toMonthNumber() {
    switch (this) {
      case 'Janeiro':
        return 1;
      case 'Fevereiro':
        return 2;
      case 'Março':
        return 3;
      case 'Abril':
        return 4;
      case 'Maio':
        return 5;
      case 'Junho':
        return 6;
      case 'Julho':
        return 7;
      case 'Agosto':
        return 8;
      case 'Setembro':
        return 9;
      case 'Outubro':
        return 10;
      case 'Novembro':
        return 11;
      case 'Dezembro':
        return 12;

      default:
        return 0;
    }
  }
}

extension MonthToName on int {
  String toMonthName({bool shortName = false}) {
    List<String> month = shortName
        ? [
            'Jan',
            'Fev',
            'Mar',
            'Abr',
            'Mai',
            'Jun',
            'Jul',
            'Ago',
            'Set',
            'Out',
            'Nov',
            'Dez'
          ]
        : [
            'Janeiro',
            'Fevereiro',
            'Março',
            'Abril',
            'Maio',
            'Junho',
            'Julho',
            'Agosto',
            'Setembro',
            'Outubro',
            'Novembro',
            'Dezembro'
          ];

    return month[this - 1];
  }
}

extension MonthExtension on String {
  int get monthNumber {
    List<String> months = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro'
    ];

    String nomeDoMes = toLowerCase();
    int indice = months.indexOf(nomeDoMes);

    return indice != -1 ? indice + 1 : -1;
  }
}

extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));
}

extension TimeOfDayExtension on TimeOfDay {
  String get timeOfDayToString {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, hour, minute);
    return DateFormat('HH:mm').format(dateTime);
  }
}

extension FinalDateExtension on String? {
  String get formatDate {
    final parsedDate = DateTime.tryParse(this ?? '');
    if (parsedDate == null) return '';
    return "${parsedDate.day.toString().padLeft(2, '0')}/${parsedDate.month.toString().padLeft(2, '0')}/${parsedDate.year}";
  }

  bool get isExpired {
    if (this == null || this!.isEmpty) return false;

    final parsedDate = DateTime.tryParse(this!);
    if (parsedDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endDate = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);

    return endDate.isBefore(today);
  }
}
