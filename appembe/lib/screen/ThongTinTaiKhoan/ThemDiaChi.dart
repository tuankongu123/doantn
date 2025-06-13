
import 'package:flutter/material.dart';

class ThemDiaChiScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;
  const ThemDiaChiScreen({super.key, required this.onSave});

  @override
  State<ThemDiaChiScreen> createState() => _ThemDiaChiScreenState();
}

class _ThemDiaChiScreenState extends State<ThemDiaChiScreen> {
  final hoTenController = TextEditingController();
  final sdtController = TextEditingController();
  final diaChiController = TextEditingController();
  bool macDinh = false;
  String loai = 'Văn phòng';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm Địa Chỉ Nhận Hàng"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Liên hệ", style: TextStyle(color: Colors.grey)),
            _buildInput(hoTenController, "Họ và tên"),
            _buildInput(sdtController, "Số điện thoại"),
            const SizedBox(height: 16),
            const Text("Địa chỉ", style: TextStyle(color: Colors.grey)),
            _buildInput(diaChiController, "Tên đường, Tòa nhà, Số nhà", suffixIcon: Icons.chevron_right),
            const SizedBox(height: 16),
            const Text("Cài đặt", style: TextStyle(color: Colors.grey)),
            SwitchListTile(
              title: const Text("Đặt làm địa chỉ mặc định"),
              value: macDinh,
              onChanged: (val) => setState(() => macDinh = val),
            ),
            const Text("Loại địa chỉ"),
            Row(
              children: [
                ChoiceChip(
                  label: const Text("Văn phòng"),
                  selected: loai == "Văn phòng",
                  onSelected: (val) => setState(() => loai = "Văn phòng"),
                ),
                const SizedBox(width: 12),
                ChoiceChip(
                  label: const Text("Nhà riêng"),
                  selected: loai == "Nhà riêng",
                  onSelected: (val) => setState(() => loai = "Nhà riêng"),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                final newData = {
                  "name": hoTenController.text,
                  "phone": sdtController.text,
                  "address": diaChiController.text,
                  "macDinh": macDinh,
                  "loai": loai,
                };
                widget.onSave(newData);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.pink, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14),
                child: Text("Xác nhận", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint, {IconData? suffixIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
