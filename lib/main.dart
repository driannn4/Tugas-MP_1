import 'package:flutter/material.dart';
import 'screens/login_screens.dart';
import 'screens/shop_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Online MP1',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),

      },
      debugShowCheckedModeBanner: false,
    );
  }
}
