import 'package:flutter/material.dart';
import 'screens/shop_screens.dart';
import 'screens/home_screens.dart';
import 'screens/cart_screens.dart';
import 'screens/profile_screens.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobile Shop',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Helvetica',
      ),
      home: const ShopScreens(),
    );
  }
}
