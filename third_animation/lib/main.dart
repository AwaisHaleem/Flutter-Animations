import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: '3rd Animation',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;

  late Tween<double> _animation;

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _xController =
        AnimationController(vsync: this, duration: const Duration(seconds: 20));
    _yController =
        AnimationController(vsync: this, duration: const Duration(seconds: 30));
    _zController =
        AnimationController(vsync: this, duration: const Duration(seconds: 40));

    _animation = Tween(begin: 0, end: 2 * pi);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();

    _yController
      ..reset()
      ..repeat();

    _zController
      ..reset()
      ..repeat();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
              width: double.infinity,
            ),
            AnimatedBuilder(
                animation: Listenable.merge(
                    [_xController, _yController, _zController]),
                builder: (context, _) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateX(_animation.evaluate(_xController))
                      ..rotateY(_animation.evaluate(_yController))
                      ..rotateZ(
                        _animation.evaluate(_xController),
                      ),
                    child: Stack(
                      children: [
                        //back
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..translate(Vector3(0, 0, -100.0)),
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.green,
                          ),
                        ),

                        //right side
                        Transform(
                          alignment: Alignment.centerRight,
                          transform: Matrix4.identity()..rotateY(-pi / 2),
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.blue,
                          ),
                        ),

                        //left side
                        Transform(
                          transform: Matrix4.identity()..rotateY(pi / 2),
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.yellow,
                          ),
                        ),

                        //top
                        Transform(
                          transform: Matrix4.identity()..rotateX(-pi / 2),
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.black,
                          ),
                        ),

                        //bottom

                        Transform(
                          transform: Matrix4.identity()..rotateX(pi / 2),
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.pink,
                          ),
                        ),

                        // front
                        Container(
                          height: 100,
                          width: 100,
                          color: Colors.red,
                        )
                      ],
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
