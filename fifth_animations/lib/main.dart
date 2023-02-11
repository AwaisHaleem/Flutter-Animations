
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
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.amber,
          iconTheme:const IconThemeData(color: Colors.white, size: 40)),
      title: 'Fifth Animation',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController rightController; // controller for right menue
  late final AnimationController leftController; // for left menu button

  @override
  void initState() {
    super.initState();
  //initialize controllers
    rightController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    leftController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
  }


// Always dispose controllers
  @override
  void dispose() {
    super.dispose();
    rightController.dispose();
    leftController.dispose();
  }

  // call back for right menu button pressed
  void onRightClick() {
    rightController.isDismissed
        ? rightController.forward()
        : rightController.reverse();
  }

// call back for left menu button pressed
  void onLeftClick() {
    leftController.isDismissed
        ? leftController.forward()
        : leftController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Floating Menu Expampls"),
      ),
      body: Container(
        alignment: Alignment.bottomRight,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //left Menu Animation
            AnimatedBuilder(
                animation: leftController,
                child: GestureDetector(
                  onTap: onLeftClick,
                  child: TopMenuButton(controller: leftController),
                ),
                builder: (context, child) {
                  return Stack(
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(
                            0.0,
                            -leftController.value * 150,
                          ),
                        child: const AddButton(),
                      ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(
                            leftController.value * 100,
                            -leftController.value * 100,
                          ),
                        child: const AddButton(),
                      ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(
                            leftController.value * 150,
                          ),
                        child: const AbcButton(),
                      ),
                      child!
                    ],
                  );
                }),

            //Right Menu Animation
            AnimatedBuilder(
                animation: rightController,
                child: GestureDetector(
                  onTap: onRightClick,
                  child: TopMenuButton(controller: rightController),
                ),
                builder: (context, child) {
                  return Stack(
                    children: [
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(
                            0.0,
                            -rightController.value * 200,
                          ),
                        child: const AddButton(),
                      ),
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()
                          ..translate(
                            0.0,
                            -rightController.value * 100,
                          ),
                        child: const AbcButton(),
                      ),
                      child!
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class AbcButton extends StatelessWidget {
  const AbcButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Button(
        child: Icon(
      Icons.abc,
    ));
  }
}

class AddButton extends StatelessWidget {
  const AddButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Button(
        child: Icon(
      Icons.add,
    ));
  }
}

class TopMenuButton extends StatelessWidget {
  const TopMenuButton({
    super.key,
    required this.controller,
  });

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Button(
      child: AnimatedIcon(icon: AnimatedIcons.menu_close, progress: controller),
    );
  }
}

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        width: 60,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black26, offset: Offset(0, 3), blurRadius: 8)
          ],
        ),
        child: child);
  }
}
