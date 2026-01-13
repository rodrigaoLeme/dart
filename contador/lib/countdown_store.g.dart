// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countdown_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CountdownStore on _CountdownStore, Store {
  late final _$hoursAtom =
      Atom(name: '_CountdownStore.hours', context: context);

  @override
  int get hours {
    _$hoursAtom.reportRead();
    return super.hours;
  }

  @override
  set hours(int value) {
    _$hoursAtom.reportWrite(value, super.hours, () {
      super.hours = value;
    });
  }

  late final _$minutesAtom =
      Atom(name: '_CountdownStore.minutes', context: context);

  @override
  int get minutes {
    _$minutesAtom.reportRead();
    return super.minutes;
  }

  @override
  set minutes(int value) {
    _$minutesAtom.reportWrite(value, super.minutes, () {
      super.minutes = value;
    });
  }

  late final _$secondsAtom =
      Atom(name: '_CountdownStore.seconds', context: context);

  @override
  int get seconds {
    _$secondsAtom.reportRead();
    return super.seconds;
  }

  @override
  set seconds(int value) {
    _$secondsAtom.reportWrite(value, super.seconds, () {
      super.seconds = value;
    });
  }

  late final _$isCountingAtom =
      Atom(name: '_CountdownStore.isCounting', context: context);

  @override
  bool get isCounting {
    _$isCountingAtom.reportRead();
    return super.isCounting;
  }

  @override
  set isCounting(bool value) {
    _$isCountingAtom.reportWrite(value, super.isCounting, () {
      super.isCounting = value;
    });
  }

  late final _$_CountdownStoreActionController =
      ActionController(name: '_CountdownStore', context: context);

  @override
  void startCountdown(int hours, int minutes, int seconds) {
    final _$actionInfo = _$_CountdownStoreActionController.startAction(
        name: '_CountdownStore.startCountdown');
    try {
      return super.startCountdown(hours, minutes, seconds);
    } finally {
      _$_CountdownStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _countDownTimer() {
    final _$actionInfo = _$_CountdownStoreActionController.startAction(
        name: '_CountdownStore._countDownTimer');
    try {
      return super._countDownTimer();
    } finally {
      _$_CountdownStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
hours: ${hours},
minutes: ${minutes},
seconds: ${seconds},
isCounting: ${isCounting}
    ''';
  }
}
