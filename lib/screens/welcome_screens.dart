import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

const Color primaryColor = Color.fromARGB(255, 255, 159, 15);

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  int _currentIndex = 0;

  final List<String> images = [
    'assets/images/welcome1.png',
    'assets/images/welcome2.png',
    'assets/images/welcome3.png',
  ];

  final List<String> captions = [
    "Layanan servis motor kini hanya dalam genggaman.",
    "Temukan bengkel terdekat dan terpercaya.",
    "Pesan, servis, dan pantau langsung dari aplikasi.",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 62, 161, 232), 
                  Color.fromARGB(255, 14, 42, 201), 
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // Konten utama
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // Judul
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: 'Mobile ', style: TextStyle(color: Colors.white)),
                        TextSpan(text: 'Bengkel', style: TextStyle(color: primaryColor)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 120),

                  // Carousel
                  CarouselSlider.builder(
                    itemCount: images.length,
                    options: CarouselOptions(
                      height: 300,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.85,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    itemBuilder: (context, index, _) {
                      return Column(
                        children: [
                          Image.asset(
                            images[index],
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            captions[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                              shadows: [
                                Shadow(
                                  blurRadius: 3,
                                  color: Colors.black45,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 16),

                  // Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: images.asMap().entries.map((entry) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == entry.key ? 12 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentIndex == entry.key
                              ? primaryColor
                              : Colors.white.withOpacity(0.4),
                        ),
                      );
                    }).toList(),
                  ),

                  const Spacer(),

                  // Info Tambahan
                  const Text(
                    "Solusi servis dan perawatan motor tanpa ribet.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tombol Login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
