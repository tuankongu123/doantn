import 'package:flutter/material.dart';
import '../../../models/SanPhamModel.dart';

class ChiTietSanPham extends StatelessWidget {
  final SanPham sanPham;

  const ChiTietSanPham({super.key, required this.sanPham});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(sanPham.ten)),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hình ảnh sản phẩm
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/${sanPham.hinhAnh}',
                        height: 300,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          size: 100,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Thông tin sản phẩm
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sanPham.ten,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${sanPham.gia.toStringAsFixed(0)}đ',
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            Chip(label: Text('Danh mục: ${sanPham.danhMuc}')),
                            Chip(label: Text('Loại: ${sanPham.loai}')),
                            Chip(label: Text('Số lượng: ${sanPham.soLuong}')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'Mô tả sản phẩm',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                sanPham.moTa.isNotEmpty
                    ? sanPham.moTa
                    : 'Chưa có mô tả cho sản phẩm này.',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
