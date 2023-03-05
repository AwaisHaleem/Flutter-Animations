import 'dart:math' as math;

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
      themeMode: ThemeMode.dark,
      title: 'Eighth Animation',
      home: const HomePage(),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  const CircleClipper();
  @override
  Path getClip(Size size) {
    var path = Path();

    var rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);

    path.addOval(rect);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color getRandomColor() {
    return Color(math.Random().nextInt(0xFF000000) + 0x00FFFFFF);
  }

  @override
  Widget build(BuildContext context) {
    var color = getRandomColor();
    return Scaffold(
      body: Center(
        child: ClipPath(
          clipper: const CircleClipper(),
          child: TweenAnimationBuilder(
              tween: ColorTween(begin: getRandomColor(), end: color),
              duration: const Duration(seconds: 1),
              onEnd: () {
                setState(() {
                  color = getRandomColor();
                });
              },
              child: Container(
                color: Colors.red,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
              ),
              builder: (context, color, child) {
                return ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    color!,
                    BlendMode.srcATop,
                  ),
                  child: child,
                );
              }),
        ),
      ),
    );
  }
}
