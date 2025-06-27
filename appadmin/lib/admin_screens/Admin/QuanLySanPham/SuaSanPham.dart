// Import chung
import 'package:flutter/material.dart';

// Màn hình sửa sản phẩm
class SuaSanPhamScreen extends StatelessWidget {
  final int sanPhamId;
  final VoidCallback onCapNhatXong;
  const SuaSanPhamScreen(
    this.sanPhamId, {
    super.key,
    required this.onCapNhatXong,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Load dữ liệu sản phẩm theo ID
    final tenController = TextEditingController(text: "Tên cũ");
    final giaController = TextEditingController(text: "100000");
    final moTaController = TextEditingController(text: "Mô tả cũ");
    final hinhAnhController = TextEditingController(text: "http://img...jpg");

    return Scaffold(
      appBar: AppBar(title: const Text("Sửa sản phẩm")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Tên sản phẩm"),
              controller: tenController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Giá"),
              keyboardType: TextInputType.number,
              controller: giaController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Hình ảnh (URL)"),
              controller: hinhAnhController,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Mô tả"),
              controller: moTaController,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Cập nhật sản phẩm qua API
                Navigator.pop(context);
                onCapNhatXong();
              },
              child: const Text("Lưu thay đổi"),
            ),
          ],
        ),
      ),
    );
  }
}
