import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedContainerScreen extends StatefulWidget {
  const AnimatedContainerScreen({super.key});

  @override
  State<AnimatedContainerScreen> createState() =>
      _AnimatedContainerScreenState();
}

class _AnimatedContainerScreenState extends State<AnimatedContainerScreen> {
  double height = 100;
  double width = 100;
  Color color = Colors.green;
  BorderRadiusGeometry radiusGeometry = BorderRadius.circular(10);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animated Container')),
      body: Center(
        child: AnimatedContainer(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: radiusGeometry,
              color: color,
            ),
            curve: Curves.fastLinearToSlowEaseIn,
            duration: const Duration(milliseconds: 500)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final random = Random();
          height = random.nextInt(300).toDouble();
          width = random.nextInt(300).toDouble();
          color = Color.fromRGBO(
              random.nextInt(256), random.nextInt(256), random.nextInt(256), 1);
          radiusGeometry = BorderRadius.circular(random.nextInt(50).toDouble());
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
