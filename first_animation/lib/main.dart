import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Animation along Y-axis',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat();
    _animation = Tween<double>(begin: 0, end: 2 * math.pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()..rotateY(_animation.value),
              alignment: Alignment.center,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.lightBlue,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow:const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 5.0),
                      blurRadius: 5,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
