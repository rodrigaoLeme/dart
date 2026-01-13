import 'dart:async';

import 'package:mobx/mobx.dart';

part 'countdown_store.g.dart';

class CountdownStore = _CountdownStore with _$CountdownStore;

abstract class _CountdownStore with Store {
  @observable
  int hours = 0;

  @observable
  int minutes = 0;

  @observable
  int seconds = 0;

  @observable
  bool isCounting = false;

  @action
  void startCountdown(int hours, int minutes, int seconds) {
    this.hours = hours;
    this.minutes = minutes;
    this.seconds = seconds;
    isCounting = true;

    _countDownTimer();
  }

  @action
  void _countDownTimer() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        seconds--;
      } else {
        if (minutes > 0) {
          minutes--;
          seconds = 59;
        } else {
          if (hours > 0) {
            hours--;
            minutes = 59;
            seconds = 59;
          } else {
            isCounting = false;
            timer.cancel();
          }
        }
      }
    });
  }
}
