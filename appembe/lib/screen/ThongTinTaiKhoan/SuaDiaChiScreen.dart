import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appembe/services/DiaChiService.dart'; // Thay đường dẫn theo đúng project của bạn

class SuaDiaChiScreen extends StatefulWidget {
  final Map<String, dynamic> diaChi;

  const SuaDiaChiScreen({required this.diaChi, Key? key}) : super(key: key);

  @override
  _SuaDiaChiScreenState createState() => _SuaDiaChiScreenState();
}

class _SuaDiaChiScreenState extends State<SuaDiaChiScreen> {
  final _tenController = TextEditingController();
  final _sdtController = TextEditingController();
  final _diaChiController = TextEditingController();
  bool isMacDinh = true;
  String loaiDiaChi = 'Văn phòng';

  @override
  void initState() {
    super.initState();
    _tenController.text = widget.diaChi['tenNguoiNhan'] ?? '';
    _sdtController.text = widget.diaChi['soDienThoai'] ?? '';
    _diaChiController.text = widget.diaChi['diaChi'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sửa Địa Chỉ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildLabel("Liên hệ"),
            buildTextField(_tenController, "Tên người nhận"),
            SizedBox(height: 12),
            buildTextField(
              _sdtController,
              "Số điện thoại",
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 12),
            buildLabel("Địa chỉ"),
            buildTextField(_diaChiController, "Địa chỉ chi tiết"),
            SizedBox(height: 12),

            SizedBox(height: 20),
            buildLabel("Cài đặt"),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("Đặt làm địa chỉ mặc định"),
              value: isMacDinh,
              onChanged: (value) {
                setState(() => isMacDinh = value);
              },
              activeColor: Colors.pink,
            ),

            Row(
              children: [
                ChoiceChip(
                  label: Text("Văn phòng"),
                  selected: loaiDiaChi == 'Văn phòng',
                  onSelected: (_) => setState(() => loaiDiaChi = 'Văn phòng'),
                  selectedColor: Colors.pink[100],
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Text("Nhà riêng"),
                  selected: loaiDiaChi == 'Nhà riêng',
                  onSelected: (_) => setState(() => loaiDiaChi = 'Nhà riêng'),
                  selectedColor: Colors.pink[100],
                ),
              ],
            ),

            SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _xoaDiaChi,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      "Xoá địa chỉ",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _capNhatDiaChi,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text("Hoàn Thành"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0, top: 16),
      child: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      keyboardType: keyboardType,
    );
  }

  void _capNhatDiaChi() async {
    String ten = _tenController.text.trim();
    String sdt = _sdtController.text.trim();
    String diaChi = _diaChiController.text.trim();

    if (ten.isEmpty || sdt.isEmpty || diaChi.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")));
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/app_api/DiaChi/Them_Dia_Chi.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "action": "sua",
          "id": widget.diaChi['id'],
          "tenNguoiNhan": ten,
          "soDienThoai": sdt,
          "diaChi": diaChi,
          "macDinh": isMacDinh ? 1 : 0,
          "loaiDiaChi": loaiDiaChi,
        }),
      );

      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("✅ Cập nhật thành công")));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("❌ Cập nhật thất bại")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Lỗi kết nối server")));
    }
  }

  void _xoaDiaChi() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Xác nhận"),
        content: Text("Bạn có chắc chắn muốn xoá địa chỉ này?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("Huỷ"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("Xoá", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await DiaChiService.xoaDiaChi(
      widget.diaChi['id'].toString(),
    );

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("✅ Đã xoá địa chỉ")));
      Navigator.pop(context, true); // hoặc chuyển về màn danh sách địa chỉ
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Xoá địa chỉ thất bại")));
    }
  }
}
