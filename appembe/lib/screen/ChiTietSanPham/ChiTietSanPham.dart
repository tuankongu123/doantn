import 'package:appembe/screen/GIoHang/GioHangScreen.dart';
import 'package:flutter/material.dart';
import '../../../model/SanPhamModel.dart';

class ChiTietSanPham extends StatelessWidget {
  final SanPham sanPham;

  const ChiTietSanPham({super.key, required this.sanPham});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sanPham.ten)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/images/${sanPham.hinhAnh}',
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image,
                    size: 100,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              sanPham.ten,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${sanPham.gia.toStringAsFixed(0)}đ',
              style: const TextStyle(
                fontSize: 22,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                Chip(label: Text('Danh mục: ${sanPham.danhMuc}')),
                Chip(label: Text('Loại: ${sanPham.loai}')),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Mô tả sản phẩm',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              sanPham.moTa.isNotEmpty
                  ? sanPham.moTa
                  : 'Chưa có mô tả cho sản phẩm này.',
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text("Thêm vào giỏ hàng"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đã thêm vào giỏ hàng")),
                  );

                  // 👇 Chuyển đến màn hình giỏ hàng
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const GioHangScreen(
                        nguoiDungId: 1,
                      ), // sửa ID tùy người dùng
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
