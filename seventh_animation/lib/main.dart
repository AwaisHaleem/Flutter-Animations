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
      title: 'Seventh Animation',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool zoomIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 370),
            curve: Curves.bounceOut,
            width: zoomIn ? MediaQuery.of(context).size.width : 100,
            child: Image.asset("assets/images/img.jpg"),
          ),
          TextButton(
              onPressed: () {
                setState(() {
                  zoomIn = !zoomIn;
                });
              },
              child: Text("Zoom ${zoomIn ? "Out" : "In"}"))
        ],
      ),
    );
  }
}
