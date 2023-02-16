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
      darkTheme: ThemeData.dark(),
      title: 'Sixth Animation',
      home: const HomePage(),
    );
  }
}

@immutable
class Person {
  final String name;
  final int age;
  final String emoji;
  const Person({
    required this.name,
    required this.age,
    required this.emoji,
  });
}

const persons = [
  Person(name: "Farmer", age: 55, emoji: "👨‍🌾"),
  Person(name: "Shef", age: 16, emoji: "👨‍🍳"),
  Person(name: "Developer", age: 18, emoji: "🧑‍💻"),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("People"),
      ),
      body: ListView.builder(
          itemCount: persons.length,
          itemBuilder: (context, index) {
            final person = persons[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(
                      person: person,
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: Hero(
                  tag: person.name,
                  child: Text(
                    person.emoji,
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                title: Text(person.name),
                subtitle: Text("${person.age} years old"),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            );
          }),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Person person;
  const DetailPage({
    Key? key,
    required this.person,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          flightShuttleBuilder: (flightContext, animation, flightDirection,
              fromHeroContext, toHeroContext) {
            switch (flightDirection) {
              case HeroFlightDirection.push:
                return Material(
                  color: Colors.transparent,
                  child: ScaleTransition(
                      scale: animation.drive(Tween<double>(begin: 0.0, end: 1)
                          .chain(CurveTween(curve: Curves.fastOutSlowIn))),
                      child: fromHeroContext.widget),
                );

              case HeroFlightDirection.pop:
                return Material(
                    color: Colors.transparent, child: toHeroContext.widget);
            }
          },
          tag: person.name,
          child: Text(
            person.emoji,
            style: const TextStyle(fontSize: 50),
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              person.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              "${person.age} years old",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
