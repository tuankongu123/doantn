import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ThemDiaChi extends StatefulWidget {
  const ThemDiaChi({Key? key}) : super(key: key);

  @override
  State<ThemDiaChi> createState() => _ThemDiaChiState();
}

class _ThemDiaChiState extends State<ThemDiaChi> {
  final _tenController = TextEditingController();
  final _sdtController = TextEditingController();
  final _diaChiController = TextEditingController();

  void _themDiaChi() async {
    final ten = _tenController.text.trim();
    final sdt = _sdtController.text.trim();
    final diaChi = _diaChiController.text.trim();

    if (ten.isEmpty || sdt.isEmpty || diaChi.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
          "http://10.0.2.2/app_api/DiaChi/Them_Dia_Chi.php",
        ), // đổi thành URL thật
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "action": "them",
          "nguoiDungId": 1,
          "tenNguoiNhan": ten,
          "soDienThoai": sdt,
          "diaChi": diaChi,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("✅ Thêm địa chỉ thành công")));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Lỗi thêm địa chỉ")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi kết nối đến server")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Thêm Địa Chỉ")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tenController,
              decoration: InputDecoration(labelText: "Tên người nhận"),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _sdtController,
              decoration: InputDecoration(labelText: "Số điện thoại"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _diaChiController,
              decoration: InputDecoration(labelText: "Địa chỉ"),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _themDiaChi,
              child: Text("Hoàn thành"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
