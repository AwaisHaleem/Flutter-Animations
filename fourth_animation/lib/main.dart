import 'dart:math';

import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      title: 'Fourth Animation',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(microseconds: 100));
    _animation = Tween(begin: 0.0, end: pi * 2.0).animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    _animationController
      ..reset()
      ..repeat();
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
                animation: _animation,
                builder: (context, _) {
                  return Transform(
                    transform: Matrix4.identity()..rotateZ(_animation.value),
                    alignment: Alignment.center,
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          stops: [0.2, 0.6, 1],
                          colors: [
                            Colors.yellowAccent,
                            Colors.redAccent,
                            Colors.greenAccent
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            Container(
              height: 170,
              width: 170,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  color: Colors.white, shape: BoxShape.circle),
              child: const Icon(
                Icons.flutter_dash,
                size: 100,
              ),
            )
          ],
        ),
      ),
    );
  }
}
