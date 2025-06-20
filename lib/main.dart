import 'package:flutter/material.dart';
import 'package:tugas_mp1/screens/login_screens.dart';
import 'package:tugas_mp1/screens/welcome_screens.dart'; // pastikan nama file & class cocok

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
/*************  ✨ Windsurf Command ⭐  *************/
  /// Builds the main MaterialApp widget for the application.
  ///

/// *****  2f5e5265-a8d3-4338-9da5-7758c903c844  ******  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas MP1',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
