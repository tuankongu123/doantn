// Import chung
import 'package:flutter/material.dart';

// Màn hình thêm sản phẩm
class ThemSanPhamScreen extends StatelessWidget {
  final VoidCallback onThemXong;
  const ThemSanPhamScreen({super.key, required this.onThemXong});

  @override
  Widget build(BuildContext context) {
    final tenController = TextEditingController();
    final giaController = TextEditingController();
    final moTaController = TextEditingController();
    final hinhAnhController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Thêm sản phẩm")),
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
                // TODO: Gửi API thêm sản phẩm
                Navigator.pop(context);
                onThemXong();
              },
              child: const Text("Thêm"),
            ),
          ],
        ),
      ),
    );
  }
}
