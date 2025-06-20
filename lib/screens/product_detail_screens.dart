import 'package:flutter/material.dart';
import 'cart_data.dart';

const Color primaryColor = Color.fromARGB(255, 240, 155, 27);

class ProductDetailScreen extends StatelessWidget {
  final String name;
  final int price;
  final String imagePath;

  const ProductDetailScreen({
    super.key,
    required this.name,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Produk"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            // Nama & Harga
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Rp$price',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Deskripsi (dummy)
            const Text(
              'Deskripsi Produk:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              'Produk ini adalah spare part berkualitas tinggi yang cocok untuk motor Anda.',
            ),

            const Spacer(),

            // Tombol tambah ke keranjang
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final index = cartItems.indexWhere((item) => item['name'] == name);
                  if (index != -1) {
                    cartItems[index]['quantity'] += 1;
                  } else {
                    cartItems.add({
                      'name': name,
                      'price': price,
                      'quantity': 1,
                    });
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('$name ditambahkan ke keranjang!'),
                      backgroundColor: primaryColor,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: const Text(
                  'Tambah ke Keranjang',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
