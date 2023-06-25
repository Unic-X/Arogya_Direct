import 'package:arogya_direct/Screens/login/login.dart';
import 'package:arogya_direct/Screens/login/manage_user.dart';
import 'package:arogya_direct/Screens/login/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:arogya_direct/Screens/welcome_screen.dart';
import 'package:arogya_direct/Screens/map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Arogya());
}

class Arogya extends StatelessWidget {
  const Arogya({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      routes: {
        '/welcome': (context) => const Welcome(),
        '/map': (context) => const MapScreen(),
      },
      title: "Fence Mate",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
    );
  }
}
