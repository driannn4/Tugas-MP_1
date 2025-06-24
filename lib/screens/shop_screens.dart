import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cart_data.dart';
import 'product_detail_screens.dart';

const Color primaryColor = Color.fromARGB(255, 240, 155, 27);
const Color backgroundColor = Color(0xFFF5F5F5);

class ShopScreens extends StatefulWidget {
  final String username;

  const ShopScreens({super.key, required this.username});

  @override
  State<ShopScreens> createState() => _ShopScreensState();
}

class _ShopScreensState extends State<ShopScreens> {
  String query = '';
  String selectedCategory = 'Semua';
  List<Map<String, dynamic>> productList = [];
  bool isLoading = true;

  List<String> categories = ['Semua'];

  void updateMerkFilter() {
    final merkSet = productList.map((p) => p['merk'].toString()).toSet();
    setState(() {
      categories = ['Semua', ...merkSet];
    });
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/products'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body); 

      setState(() {
        productList = data.map<Map<String, dynamic>>((item) => {
              'id': item['id'],
              'name': item['name'],
              'price': double.tryParse(item['price'].toString()) ?? 0,
              'imagePath': item['image_url'],
              'merk': item['merk'],
              'stock': item['stock'],
              'description': item['description'],
            }).toList();
        isLoading = false;
      });
      updateMerkFilter();
    } else {
      setState(() => isLoading = false);
      print("Gagal mengambil produk: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredProducts = productList.where((product) {
      final nameMatch = product['name'].toLowerCase().contains(query.toLowerCase());
      final categoryMatch = selectedCategory == 'Semua' ||
          product['merk'].toLowerCase() == selectedCategory.toLowerCase();
      return nameMatch && categoryMatch;
    }).toList();

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: TextField(
                  onChanged: (val) => setState(() => query = val),
                  decoration: const InputDecoration(
                    icon: Icon(Icons.search, color: primaryColor),
                    hintText: 'Cari produk...',
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Kategori Merk
              const Text(
                'Kategori Produk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: categories.map((cat) {
                    final selected = cat == selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: selected,
                        onSelected: (_) => setState(() => selectedCategory = cat),
                        selectedColor: primaryColor,
                        backgroundColor: Colors.white,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // Jumlah Produk
              Text(
                '${filteredProducts.length} produk ditemukan',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),

              // Grid Produk
              isLoading
                  ? const Expanded(child: Center(child: CircularProgressIndicator()))
                  : Expanded(
                      child: filteredProducts.isEmpty
                          ? const Center(
                              child: Text(
                                'Produk tidak ditemukan',
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: GridView.builder(
                                itemCount: filteredProducts.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 3 / 4,
                                ),
                                itemBuilder: (context, index) {
                                  final product = filteredProducts[index];
                                  return ShopProductCard(
                                    id:product['id'],
                                    name: product['name'],
                                    price: product['price'],
                                    imagePath: product['imagePath'],
                                    merk: product['merk'],
                                  );
                                },
                              ),
                            ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========================== CARD PRODUK ==========================

class ShopProductCard extends StatelessWidget {
  final int id;
  final String name;
  final double price;
  final String imagePath;
  final String merk;

  const ShopProductCard({
    super.key,
   required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.merk,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imagePath,
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
                const SizedBox(height: 8),
                // Expanded isi
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        merk,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rp${price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => ProductDetailScreen(productId: id),
  ),
);

                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(color: primaryColor),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "Lihat Detail",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.add_shopping_cart,
                            color: Colors.white, size: 20),
                        onPressed: () {
                          final index =
                              cartItems.indexWhere((item) => item['name'] == name);
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
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
