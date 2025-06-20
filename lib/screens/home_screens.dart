import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(255, 240, 155, 27);

class HomeScreens extends StatelessWidget {
  final String username;

  const HomeScreens({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hai, $username 👋',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const CircleAvatar(
                    backgroundColor: Color(0xFFFFE0B2),
                    child: Icon(Icons.person, color: primaryColor),
                  ),
                  onSelected: (value) {
                    if (value == 'logout') {
                      Navigator.pushReplacementNamed(context, '/login');
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: 'logout',
                      child: Text('Logout'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Cari layanan atau suku cadang...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Promo Banner
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/banner.jpg',
                height: 140,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32),

            // Kategori Motor
            const Text(
              'Kategori Motor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                CategoryIcon(name: 'Honda', image: 'assets/images/logohonda.png'),
                CategoryIcon(name: 'Yamaha', image: 'assets/images/yamaha.png'),
                CategoryIcon(name: 'Suzuki', image: 'assets/images/suzuki.png'),
                CategoryIcon(name: 'Lainnya', image: 'assets/images/lainnya.png'),
              ],
            ),
            const SizedBox(height: 32),

            // Layanan Populer
            const Text(
              'Layanan Populer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: const [
                ServiceItem(name: 'Servis', icon: Icons.build),
                ServiceItem(name: 'Ganti Oli', icon: Icons.oil_barrel),
                ServiceItem(name: 'Ban & Rem', icon: Icons.tire_repair),
                ServiceItem(name: 'Suku Cadang', icon: Icons.storefront),
                ServiceItem(name: 'Cuci Motor', icon: Icons.local_car_wash),
                ServiceItem(name: 'Aki & Busi', icon: Icons.bolt),
                ServiceItem(name: 'Tune Up', icon: Icons.settings),
                ServiceItem(name: 'Emergency', icon: Icons.warning),
              ],
            ),
            const SizedBox(height: 32),

            // Tips Otomotif
            const Text(
              'Tips Otomotif Hari Ini',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Pastikan tekanan angin ban motor selalu sesuai agar berkendara lebih aman dan irit bahan bakar.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryIcon extends StatelessWidget {
  final String name;
  final String image;

  const CategoryIcon({super.key, required this.name, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(image),
        ),
        const SizedBox(height: 6),
        Text(name, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class ServiceItem extends StatelessWidget {
  final String name;
  final IconData icon;

  const ServiceItem({super.key, required this.name, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundColor: primaryColor.withOpacity(0.15),
          child: Icon(icon, color: primaryColor, size: 24),
        ),
        const SizedBox(height: 6),
        Text(name, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
