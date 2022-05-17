import 'package:flutter/material.dart';

class HomePageAnimation extends StatefulWidget {
  const HomePageAnimation({Key? key}) : super(key: key);

  @override
  State<HomePageAnimation> createState() => _HomePageAnimationState();
}

class _HomePageAnimationState extends State<HomePageAnimation> {
  var isSelected = false;

  @override
  Widget build(BuildContext context) {
    //Color.lerp();

    return Material(
      child: Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(seconds: 5),
            height: 80,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(80),
              color: Colors.grey,
            ),
            child: AnimatedAlign(
              duration: const Duration(seconds: 2),
              curve: Curves.elasticIn,
              alignment:
                  isSelected ? Alignment.centerRight : Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(seconds: 2),
                width: 150,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    color: isSelected ? Colors.red : Colors.grey[700]),
                //color: Colors.red),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
