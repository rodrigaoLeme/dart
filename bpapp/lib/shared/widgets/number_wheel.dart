import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class NumberWheelController extends ValueNotifier<int> {
  NumberWheelController(int value) : super(value);
}

class NumberWheel extends StatefulWidget {
  final int min;
  final int max;
  final int? padLength;
  final TextStyle? textStyle;
  final TextStyle? selectedTextStyle;
  final double diameterRadio;
  final NumberWheelController controller;

  const NumberWheel({
    Key? key,
    required this.max,
    required this.controller,
    this.min = 0,
    this.padLength,
    this.textStyle,
    this.diameterRadio = RenderListWheelViewport.defaultDiameterRatio,
    this.selectedTextStyle,
  }) : super(key: key);

  @override
  _NumberWheelState createState() => _NumberWheelState();
}

class _NumberWheelState extends State<NumberWheel> {
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = FixedExtentScrollController(
        initialItem: widget.controller.value - widget.min);
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      itemExtent: 44,
      controller: _scrollController,
      diameterRatio: 1.2,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (index) {
        widget.controller.value = index;
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: widget.max - widget.min + 1,
        builder: (context, index) {
          return ValueListenableBuilder(
            valueListenable: widget.controller,
            builder: (context, value, child) {
              return Center(
                child: Text(
                  (index + widget.min)
                      .toString()
                      .padLeft(widget.padLength ?? 0, "0"),
                  style: index == value
                      ? widget.selectedTextStyle
                      : widget.textStyle,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
