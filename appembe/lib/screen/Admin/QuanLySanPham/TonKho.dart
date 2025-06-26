// Import chung
import 'package:flutter/material.dart';

// Màn hình tồn kho (hiện số lượng hiện tại)
class TonKhoScreen extends StatelessWidget {
  final int sanPhamId;
  const TonKhoScreen(this.sanPhamId, {super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Fetch từ API số lượng tồn kho
    final int soLuongTonKho = 120;
    return Scaffold(
      appBar: AppBar(title: const Text("Tồn kho sản phẩm")),
      body: Center(
        child: Text(
          "Số lượng hiện tại: $soLuongTonKho",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
