import 'package:appembe/widget/GoiYDiaChi.dart';
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
  final _diaChiController = TextEditingController(); // Cho phép nhập bằng tay
  bool _showError = false;
  bool _isDefault = false;
  String _loaiDiaChi = "Văn phòng";

  void _themDiaChi() async {
    setState(() {
      _showError = true;
    });

    final ten = _tenController.text.trim();
    final sdt = _sdtController.text.trim();
    final diaChi = _diaChiController.text.trim();

    if (ten.isEmpty || sdt.isEmpty || diaChi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/app_api/DiaChi/Them_Dia_Chi.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "action": "them",
          "nguoiDungId": 1, // Hoặc truyền từ màn hình trước nếu có
          "tenNguoiNhan": ten,
          "soDienThoai": sdt,
          "diaChi": diaChi,
        }),
      );

      final data = jsonDecode(response.body);
      print(data); // Debug

      if (data["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Thêm địa chỉ thành công")),
        );
        Navigator.pop(context, true); // Trả kết quả về màn trước
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ ${data["message"] ?? "Lỗi thêm địa chỉ"}")),
        );
      }
    } catch (e) {
      print("Lỗi: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Lỗi kết nối đến server")));
    }
  }

  Future<void> _chonDiaChi() async {
    final diaChiChon = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GoiYDiaChi()),
    );

    if (diaChiChon != null && diaChiChon is String) {
      setState(() {
        _diaChiController.text = diaChiChon;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm Địa Chỉ Nhận Hàng")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Liên hệ", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            TextField(
              controller: _tenController,
              decoration: InputDecoration(
                labelText: "Họ và tên",
                errorText: _showError && _tenController.text.trim().isEmpty
                    ? "Vui lòng nhập vào Họ và tên"
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _sdtController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Số điện thoại",
                errorText: _showError && _sdtController.text.trim().isEmpty
                    ? "Vui lòng nhập vào Số điện thoại"
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _diaChiController,
                    readOnly: false,
                    decoration: InputDecoration(
                      labelText: "Tên đường, Tòa nhà, Số nhà",
                      errorText:
                          _showError && _diaChiController.text.trim().isEmpty
                          ? "Vui lòng nhập địa chỉ"
                          : null,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _chonDiaChi,
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Cài đặt", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Đặt làm địa chỉ mặc định"),
                Switch(
                  value: _isDefault,
                  onChanged: (value) => setState(() => _isDefault = value),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text("Loại địa chỉ"),
            const SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: const Text("Văn phòng"),
                  selected: _loaiDiaChi == "Văn phòng",
                  onSelected: (_) => setState(() => _loaiDiaChi = "Văn phòng"),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text("Nhà riêng"),
                  selected: _loaiDiaChi == "Nhà riêng",
                  onSelected: (_) => setState(() => _loaiDiaChi = "Nhà riêng"),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _themDiaChi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Xác nhận"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
