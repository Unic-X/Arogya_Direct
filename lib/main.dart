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
      title: "ArogyaDirect",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapScreen(),
    );
  }
}
