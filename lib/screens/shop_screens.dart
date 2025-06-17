import 'package:flutter/material.dart';
import 'home_screens.dart';
import 'cart_screens.dart';
import 'profile_screens.dart';

class ShopScreens extends StatefulWidget {
  const ShopScreens({super.key});

  @override
  State<ShopScreens> createState() => _ShopScreensState();
}

class _ShopScreensState extends State<ShopScreens> {
  int _currentIndex = 1;

  final List<Widget> _screens = const [
    HomeScreen(),
    ShopContent(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class ShopContent extends StatelessWidget {
  const ShopContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: const Color(0xFFF1F8F5), // modern soft green background
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar dan icon profil
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.green),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.green),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Shop!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: const [
                  ShopItem(icon: Icons.checkroom, label: 'Clothes'),
                  ShopItem(icon: Icons.remove_red_eye, label: 'Accessories'),
                  ShopItem(icon: Icons.directions_run, label: 'Sports'),
                  ShopItem(icon: Icons.local_mall, label: 'Bag'),
                  ShopItem(icon: Icons.videogame_asset, label: 'Games'),
                  ShopItem(icon: Icons.shopping_bag, label: 'Shoes'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShopItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const ShopItem({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.green, size: 48),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}
