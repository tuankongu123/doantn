import 'package:flutter/material.dart';

class ChiTietSanPhamScreen extends StatelessWidget {
  final Map<String, dynamic> sanPham;

  const ChiTietSanPhamScreen({super.key, required this.sanPham});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sanPham['ten'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.network(sanPham['image'], height: 200),
            const SizedBox(height: 16),
            Text(
              sanPham['ten'],
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Thương hiệu: ${sanPham['thuongHieu']}',
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Text(
              '${sanPham['gia']}đ',
              style: const TextStyle(fontSize: 20, color: Colors.red),
            ),
            const Divider(height: 30),
            Text(sanPham['moTa'], style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart),
                label: const Text("Thêm vào giỏ hàng"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
