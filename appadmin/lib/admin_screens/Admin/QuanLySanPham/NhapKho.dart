// Import chung
import 'package:flutter/material.dart';

// Màn hình nhập kho
class NhapKhoScreen extends StatelessWidget {
  final int sanPhamId;
  final VoidCallback onNhapXong;
  const NhapKhoScreen(this.sanPhamId, {super.key, required this.onNhapXong});

  @override
  Widget build(BuildContext context) {
    final soLuongController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Nhập kho")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: "Số lượng nhập thêm",
              ),
              keyboardType: TextInputType.number,
              controller: soLuongController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Gửi API cập nhật kho
                Navigator.pop(context);
                onNhapXong();
              },
              child: const Text("Xác nhận"),
            ),
          ],
        ),
      ),
    );
  }
}
