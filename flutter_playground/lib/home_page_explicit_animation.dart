import 'package:flutter/material.dart';

class HomePageExplcitAnimation extends StatefulWidget {
  const HomePageExplcitAnimation({Key? key}) : super(key: key);

  @override
  State<HomePageExplcitAnimation> createState() =>
      _HomePageExplcitAnimationState();
}

class _HomePageExplcitAnimationState extends State<HomePageExplcitAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation sizeSquare;
  late Animation ovalTransformAnimation;
  late Animation colorAnimation;

  @override
  void initState() {
    super.initState();
    const duration = Duration(seconds: 5);
    _controller = AnimationController(vsync: this, duration: duration);
    _controller.addListener(() {
      setState(() {});
      //print(_controller.value);
    });

    sizeSquare = Tween<double>(begin: 100, end: 200).animate(CurvedAnimation(
        parent: _controller,
        reverseCurve: const Interval(0.0, 0.2, curve: Curves.bounceIn),
        curve: const Interval(0.0, 0.2, curve: Curves.bounceInOut)));

    colorAnimation = ColorTween(begin: Colors.red, end: Colors.blue).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0)));

    ovalTransformAnimation = Tween<double>(begin: 10, end: 100).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.5, curve: Curves.ease)));
  }

  var isSelected = false;

  double range(double start, double end, double x) {
    var value = end - start;
    value = value * x;
    value += start;
    return value;
  }

  @override
  Widget build(BuildContext context) {
    const size = 200.0;
    return Material(
      child: Center(
        child: GestureDetector(
          onTap: () {
            if (_controller.isCompleted) {
              _controller.reverse();
            } else {
              _controller.forward();
            }
          },
          child: Center(
            child: Container(
              //height: range(100, 200, _controller.value),
              //width: range(100, 200, _controller.value),
              //color: Colors.red,
              //color: Color.lerp(Colors.red, Colors.blue, _controller.value),
              height: sizeSquare.value,
              width: sizeSquare.value,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(ovalTransformAnimation.value),
                color: colorAnimation.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
