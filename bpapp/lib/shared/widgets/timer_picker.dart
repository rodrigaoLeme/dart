import 'package:bibleplan/common.dart';
import 'package:bibleplan/shared/widgets/number_wheel.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter/painting.dart';
//import 'package:flutter/widgets.dart';

class TimerPickerController extends ValueNotifier<TimeOfDay> {
  TimerPickerController(TimeOfDay value) : super(value);
}

class TimerPicker extends StatefulWidget {
  final double height;
  final TimerPickerController controller;

  const TimerPicker({Key? key, this.height = 200, required this.controller})
      : super(key: key);

  @override
  _TimerPickerState createState() => _TimerPickerState();
}

class _TimerPickerState extends State<TimerPicker> {
  late NumberWheelController hourController;
  late NumberWheelController minController;

  @override
  void initState() {
    super.initState();
    hourController = NumberWheelController(widget.controller.value.hour);
    minController = NumberWheelController(widget.controller.value.minute);
    hourController.addListener(_hourChanged);
    minController.addListener(_hourChanged);
  }

  @override
  void dispose() {
    hourController.removeListener(_hourChanged);
    minController.removeListener(_hourChanged);
    super.dispose();
  }

  void _hourChanged() {
    widget.controller.value =
        TimeOfDay(hour: hourController.value, minute: minController.value);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 74,
            child: NumberWheel(
              max: 23,
              controller: hourController,
              padLength: 2,
              textStyle: TextStyle(
                  color: AppStyle.secondaryVariant.withAlpha(100),
                  fontSize: 32),
              selectedTextStyle: TextStyle(
                  color: AppStyle.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 32),
            ),
          ),
          Txt.b(":", color: AppStyle.primaryColor, size: 32),
          SizedBox(
            width: 74,
            child: NumberWheel(
              max: 59,
              controller: minController,
              padLength: 2,
              textStyle: TextStyle(
                  color: AppStyle.secondaryVariant.withAlpha(100),
                  fontSize: 32),
              selectedTextStyle: TextStyle(
                  color: AppStyle.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 32),
            ),
          )
        ],
      ),
    );
  }
}
