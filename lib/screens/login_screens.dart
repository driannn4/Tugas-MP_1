import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/welcome');
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Image.asset('assets/images/Logo.png', height: 120),
                  const SizedBox(height: 10),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: 'Mobile ', style: TextStyle(color: Colors.black)),
                        TextSpan(text: 'Bengkel', style: TextStyle(color: Colors.orange)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    color: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Welcome Back!',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: const Icon(Icons.person),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Forgot Password"),
                                    content: const Text("Silakan hubungi admin untuk reset password."),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () async {
                              final email = _usernameController.text.trim();
                              final password = _passwordController.text.trim();

                              if (email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Email dan password tidak boleh kosong"),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                                return;
                              }

                              try {
                                final response = await http.post(
                                  Uri.parse('http://10.0.2.2:8000/api/customer/login'),
                                  headers: {'Accept': 'application/json'},
                                  body: {
                                    'email': email,
                                    'password': password,
                                  },
                                );

                                if (response.statusCode == 200) {
                                  final data = jsonDecode(response.body);
                                  final token = data['token'];

                                  const storage = FlutterSecureStorage();
                                  await storage.write(key: 'token', value: token);

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MainNavigation(username: data['customer']['name']),
                                    ),
                                  );
                                } else {
                                  final data = jsonDecode(response.body);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(data['message'] ?? 'Login gagal'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: ${e.toString()}'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 255, 193, 48),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text('Login', style: TextStyle(fontSize: 18)),
                          ),
                          const SizedBox(height: 20),
                          const Center(
                            child: Text(
                              "Don't have an account?",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton(
                            onPressed: () async {
                              try {
                                print("Memulai proses login Google...");
                                final GoogleSignIn googleSignIn = GoogleSignIn();
                                final GoogleSignInAccount? account = await googleSignIn.signIn();

                                if (account == null) {
                                  print("Login dibatalkan oleh user");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Login dibatalkan")),
                                  );
                                  return;
                                }

                                print("Login berhasil. Akun: ${account.email}");
                                final GoogleSignInAuthentication auth = await account.authentication;

                                print("Access Token: ${auth.accessToken}");
                                print("ID Token: ${auth.idToken}");

                                final idToken = auth.idToken;
                                if (idToken == null) {
                                  print("Gagal mendapatkan ID Token");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Gagal mendapatkan ID Token')),
                                  );
                                  return;
                                }

                                final response = await http.post(
                                  Uri.parse('http://10.0.2.2:8000/api/auth/google'),
                                  headers: {'Accept': 'application/json'},
                                  body: {'id_token': idToken},
                                );

                                print("Response dari Laravel: ${response.statusCode}");
                                print("Body: ${response.body}");

                                if (response.statusCode == 200) {
                                  final data = jsonDecode(response.body);
                                  final token = data['token'];

                                  const storage = FlutterSecureStorage();
                                  await storage.write(key: 'token', value: token);

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MainNavigation(username: data['customer']['name']),
                                    ),
                                  );
                                } else {
                                  final data = jsonDecode(response.body);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(data['message'] ?? 'Login Google gagal'),
                                      backgroundColor: Colors.redAccent,
                                    ),
                                  );
                                }
                              } catch (e) {
                                print("Error saat login Google: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Login error: $e'),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              side: const BorderSide(color: Colors.grey),
                              foregroundColor: const Color.fromARGB(221, 0, 0, 0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/Google.webp',
                                  height: 24,
                                ),
                                const SizedBox(width: 10),
                                const Text(
                                  'Login with Google',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
