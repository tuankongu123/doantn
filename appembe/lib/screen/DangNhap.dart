import 'package:flutter/material.dart';

class Mh_DangNhap extends StatelessWidget {
  const Mh_DangNhap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng nhập")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: 'Số điện thoại'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Xử lý đăng nhập
              },
              child: const Text("Gửi OTP"),
            ),
          ],
        ),
      ),
    );
  }
}
