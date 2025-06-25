import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as DatePicker;
import 'package:intl/intl.dart';

class SoBeYeuScreen extends StatefulWidget {
  const SoBeYeuScreen({super.key});

  @override
  State<SoBeYeuScreen> createState() => _ThemBeYeuScreenState();
}

class _ThemBeYeuScreenState extends State<SoBeYeuScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tenBeController = TextEditingController();
  final TextEditingController _ngaySinhController = TextEditingController();

  String _gioiTinh = 'Nam';
  DateTime? _ngaySinh;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thêm Bé Yêu")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tenBeController,
                decoration: const InputDecoration(
                  labelText: "Tên bé",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? "Vui lòng nhập tên bé"
                    : null,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  // DatePicker.showDatePicker(
                  //   context,
                  //   showTitleActions: true,
                  //   maxTime: DateTime.now(),
                  //   minTime: DateTime(2000),
                  //   currentTime: _ngaySinh ?? DateTime.now(),
                  //   locale: LocaleType.vi,
                  //   onConfirm: (date) {
                  //     setState(() {
                  //       _ngaySinh = date;
                  //       _ngaySinhController.text =
                  //           DateFormat('dd/MM/yyyy').format(date);
                  //     });
                  //   },
                  // );
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _ngaySinhController,
                    decoration: const InputDecoration(
                      labelText: "Ngày sinh",
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Chọn ngày sinh"
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _gioiTinh,
                items: ['Nam', 'Nữ']
                    .map((gt) => DropdownMenuItem(value: gt, child: Text(gt)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _gioiTinh = value;
                    });
                  }
                },
                decoration: const InputDecoration(
                  labelText: "Giới tính",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _luuThongTin,
                child: const Text("Lưu"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _luuThongTin() {
    if (_formKey.currentState?.validate() != true) return;

    final tenBe = _tenBeController.text.trim();
    final ngaySinh = _ngaySinhController.text.trim();
    final gioiTinh = _gioiTinh;

    print("🎉 Tên: $tenBe");
    print("📅 Ngày sinh: $ngaySinh");
    print("👶 Giới tính: $gioiTinh");

    // Gửi API ở đây nếu cần...

    Navigator.pop(context, true); // Quay về và refresh danh sách
  }
}
