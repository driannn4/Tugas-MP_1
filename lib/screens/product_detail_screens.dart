import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cart_data.dart';

const Color primaryColor = Color.fromARGB(255, 240, 155, 27);

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Map<String, dynamic>? product;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProductDetail();
  }

  Future<void> fetchProductDetail() async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/products/${widget.productId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        final jsonData = json.decode(response.body);
        product = jsonData is Map && jsonData.containsKey('data') ? jsonData['data'] : jsonData;

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print("Gagal ambil detail produk: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return const Scaffold(
        body: Center(child: Text("Produk tidak ditemukan")),
      );
    }

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
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product!['image_url'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              product!['name'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Rp${double.tryParse(product!['price'].toString())?.toStringAsFixed(0) ?? "0"}',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              product!['merk'] ?? '',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            const Text(
              'Deskripsi Produk:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(product!['description'] ?? '-'),
            const Spacer(),
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
                  final name = product!['name'];
                  final price = double.tryParse(product!['price'].toString()) ?? 0;
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
