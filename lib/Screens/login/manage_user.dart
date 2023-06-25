import 'package:arogya_direct/Screens/login/login.dart';
import 'package:arogya_direct/Screens/login/register.dart';
import 'package:arogya_direct/Screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Welcome();
          } else {
            return RegisterPage();
          }
        },
      ),
    );
  }
}
