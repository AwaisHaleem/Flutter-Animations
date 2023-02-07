import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circle Animation',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

enum CircleSide { left, right }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();

    late Offset offset;
    late bool clockwise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offset = Offset(size.width, size.height);
        clockwise = false;
        break;
      case CircleSide.right:
        offset = Offset(0, size.height);
        clockwise = true;
        break;
    }

    path.arcToPoint(
      offset,
      radius: Radius.elliptical(
        size.width / 2,
        size.height / 2,
      ),
      clockwise: clockwise,
    );
    path.close();
    return path;
  }
}

extension on VoidCallback {
  Future<void> delayed(Duration duration) => Future.delayed(duration, this);
}

class HalfCircle extends CustomClipper<Path> {
  final CircleSide side;

  HalfCircle({required this.side});

  @override
  Path getClip(Size size) {
    return side.toPath(size);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController antiClockwiseAnimationController;
  late Animation<double> antiClockWiseAnimation;
  late AnimationController flipAnimationController;
  late Animation<double> flipAnimation;

  @override
  void initState() {
    super.initState();

    antiClockwiseAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    antiClockWiseAnimation = Tween<double>(begin: 0, end: -(pi / 2)).animate(
        CurvedAnimation(
            parent: antiClockwiseAnimationController, curve: Curves.bounceOut));

    // flip animation controller
    flipAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: flipAnimationController, curve: Curves.bounceOut),
    );

    // status listener
    antiClockwiseAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        flipAnimation = Tween<double>(
                begin: flipAnimation.value, end: flipAnimation.value + pi)
            .animate(CurvedAnimation(
                parent: flipAnimationController, curve: Curves.bounceOut));
        flipAnimationController
          ..reset()
          ..forward();
      }
    });

    flipAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        antiClockWiseAnimation = Tween<double>(
                begin: antiClockWiseAnimation.value,
                end: antiClockWiseAnimation.value + -pi / 2)
            .animate(
          CurvedAnimation(
              parent: antiClockwiseAnimationController,
              curve: Curves.bounceOut),
        );
        antiClockwiseAnimationController
          ..reset()
          ..forward();
      }
    });
  }

  @override
  void dispose() {
    antiClockwiseAnimationController.dispose();
    flipAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    antiClockwiseAnimationController
      ..reset()
      ..forward.delayed(const Duration(seconds: 1));

    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
            animation: antiClockWiseAnimation,
            builder: (context, _) {
              return Transform(
                transform: Matrix4.identity()
                  ..rotateZ(antiClockWiseAnimation.value),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                        animation: flipAnimation,
                        builder: (context, _) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..rotateY(flipAnimation.value),
                            alignment: Alignment.centerRight,
                            child: ClipPath(
                              clipper: HalfCircle(side: CircleSide.left),
                              child: Container(
                                width: 200,
                                height: 200,
                                color: Colors.blue,
                              ),
                            ),
                          );
                        }),
                    AnimatedBuilder(
                        animation: flipAnimation,
                        builder: (context, _) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..rotateY(flipAnimation.value),
                            alignment: Alignment.centerLeft,
                            child: ClipPath(
                              clipper: HalfCircle(side: CircleSide.right),
                              child: Container(
                                width: 200,
                                height: 200,
                                color: Colors.yellow,
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
