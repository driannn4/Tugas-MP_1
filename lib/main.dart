import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/welcome_screens.dart';
import 'screens/login_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas MP1',
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // WelcomeScreen jadi halaman awal
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/welcome': (context) => const WelcomeScreen(), // Tambahkan ini
        '/login': (context) => const LoginPage(),
        // '/main': (context) => MainNavigation(username: '...'), // Jika dibutuhkan nanti
      },
    );
  }
}
