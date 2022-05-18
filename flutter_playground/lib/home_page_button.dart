import 'package:flutter/material.dart';

class HomePageButtonAnimation extends StatefulWidget {
  const HomePageButtonAnimation({Key? key}) : super(key: key);

  @override
  State<HomePageButtonAnimation> createState() =>
      _HomePageButtonAnimationState();
}

class _HomePageButtonAnimationState extends State<HomePageButtonAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation sizeAnimation;
  late Animation ovalTransformAnimation;
  late Animation loadingOpacityAnimation;
  late Animation textOpacityAnimation;

  @override
  void initState() {
    super.initState();
    const duration = Duration(seconds: 5);
    _controller = AnimationController(vsync: this, duration: duration);
    _controller.addListener(() {
      setState(() {});
      //print(_controller.value);
    });

    sizeAnimation = Tween<double>(begin: 400, end: 80).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.7, curve: Curves.bounceOut)));

    ovalTransformAnimation = Tween<double>(begin: 10, end: 100).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.2, 0.5, curve: Curves.ease)));

    textOpacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.0,
          0.3,
          curve: Curves.ease,
        ),
      ),
    );

    loadingOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.6,
          1.0,
          curve: Curves.ease,
        ),
      ),
    );
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
              height: 80,
              width: sizeAnimation.value,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(ovalTransformAnimation.value),
                color: Colors.blue,
              ),
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: textOpacityAnimation.value,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: loadingOpacityAnimation.value,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
