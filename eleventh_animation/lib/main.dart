import 'dart:async';

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
      theme: ThemeData(brightness: Brightness.dark),
      title: 'Eleventh Animation',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Icon")),
      body: const SuccessPrompt(),
    );
  }
}

class SuccessPrompt extends StatefulWidget {
  const SuccessPrompt({super.key});

  @override
  State<SuccessPrompt> createState() => _SuccessPromptState();
}

class _SuccessPromptState extends State<SuccessPrompt>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _yAnimation;
  late Animation<double> _childAnimation;
  late Animation<double> _widgetAnimation;
  StreamController _streamController = StreamController();

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _yAnimation = Tween<Offset>(begin: Offset.zero, end: Offset(0, 0.30))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    super.initState();
    _widgetAnimation = Tween<double>(begin: 1.0, end: 3.1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _childAnimation = Tween<double>(begin: 1.0, end: 0.7)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void runAnimationOnce() async {
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    await _controller.reverse();
  }

  void repeatAnimation() {
    _controller.addStatusListener((status) {
      if (AnimationStatus.dismissed == status) {
        Future.delayed(Duration(milliseconds: 100), () => runAnimationOnce());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    runAnimationOnce();
    // repeatAnimation();
    return Center(
      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20), color: Colors.white),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: 100,
              minWidth: 100,
              maxHeight: MediaQuery.of(context).size.height * 0.8,
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Stack(alignment: Alignment.topCenter, children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    SizedBox(
                      height: 160,
                    ),
                    Text(
                      "Successful",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Thanks For Shopping, You'r order will be deilevered tomorrow",
                      style: TextStyle(color: Colors.black54, fontSize: 18),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                SlideTransition(
                  position: _yAnimation,
                  child: ScaleTransition(
                    scale: _widgetAnimation,
                    child: Container(
                      height: 140,
                      width: 140,
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                      child: ScaleTransition(
                        scale: _childAnimation,
                        child: const Icon(
                          Icons.check,
                          size: 140,
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
