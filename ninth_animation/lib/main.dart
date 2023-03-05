import 'package:flutter/material.dart';
import 'dart:math' show pi, sin, cos;

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
      title: 'Ninth Animation',
      home: const HomePage(),
    );
  }
}

class Polygon extends CustomPainter {
  final int sides;
  Polygon({
    required this.sides,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    final angle = (2 * pi) / sides;

    final angles = List.generate(sides, (index) => index * angle);

    final radius = size.width / 2;

    var path = Path();

    path.moveTo(
      center.dx + radius * cos(0),
      center.dy + radius * sin(0),
    );

    for (final angle in angles) {
      path.lineTo(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
    }

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is Polygon && oldDelegate.sides != sides;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _sideAnimationController;
  late AnimationController _sizeController;
  late AnimationController _axisController;
  late Animation<int> _sideAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<double> _axisAnimation;

  @override
  void initState() {
    super.initState();

    _sideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 3,
      ),
    );

    _sizeController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 3,
      ),
    );
    _axisController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 3,
      ),
    );

    _sideAnimation =
        IntTween(begin: 3, end: 10).animate(_sideAnimationController);
    _sizeAnimation = Tween<double>(begin: 20, end: 400)
        .chain(CurveTween(curve: Curves.bounceInOut))
        .animate(_sizeController);
    _axisAnimation = Tween<double>(begin: 0, end: 2 * pi)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_sizeController);
  }

  @override
  void dispose() {
    _sideAnimationController.dispose();
    _sizeController.dispose();
    _axisController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _sideAnimationController.repeat(reverse: true);
    _sizeController.repeat(reverse: true);
    _axisController.repeat(reverse: true);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
            animation: Listenable.merge([
              _sideAnimationController,
              _sizeController,
            ]),
            builder: (context, _) {
              return Transform(
                transform: Matrix4.identity()
                  ..rotateX(_axisAnimation.value)
                  ..rotateY(_axisAnimation.value)
                  ..rotateZ(
                    _axisAnimation.value,
                  ),
                alignment: Alignment.center,
                child: CustomPaint(
                  painter: Polygon(sides: _sideAnimation.value),
                  child: SizedBox(
                    height: _sizeAnimation.value,
                    width: _sizeAnimation.value,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
