import 'package:flutter/material.dart';
import 'package:arogya_direct/Screens/map.dart';

void main() {
  runApp(const Arogya());
}

class Arogya extends StatelessWidget {
  const Arogya({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ArogyaDirect",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(),
          shadowColor: Color.fromARGB(190, 11, 66, 216),
        ),
        primarySwatch: Colors.deepPurple,
      ),
      home: const MapScreen(),
    );
  }
}
