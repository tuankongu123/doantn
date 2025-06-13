// File: lib/screens/account/thong_tin_ca_nhan.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class ThongTinCaNhanScreen extends StatefulWidget {
  const ThongTinCaNhanScreen({super.key});

  @override
  State<ThongTinCaNhanScreen> createState() => _ThongTinCaNhanScreenState();
}

class _ThongTinCaNhanScreenState extends State<ThongTinCaNhanScreen> {
  final TextEditingController _tenController = TextEditingController();
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _NgayThangNamSinhController = TextEditingController();
  final TextEditingController _gioiTinhController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('vi_VN', null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Thông Tin Của Tôi",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Vui lòng xác nhận đầy đủ thông tin bên dưới để nhận ưu đãi đặc biệt",
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            _buildTextField(_tenController, hintText: "Họ và Tên"),
            _buildTextField(
              _sdtController,
              hintText: "Số điện thoại liên lạc",
              fillColor: Colors.pink[50],
            ),
            _buildTextField(
              _emailController,
              hintText: "Email liên lạc",
              enabled: true,
            ),
            GestureDetector(
              onTap: () => _chonNgaySinh(context),
              child: AbsorbPointer(
                child: _buildTextField(
                  _NgayThangNamSinhController,
                  hintText: "Ngày sinh",
                  enabled: false,
                  suffixIcon: Icons.calendar_today,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _chonGioiTinh(context),
              child: AbsorbPointer(
                child: _buildTextField(
                  _gioiTinhController,
                  hintText: "Giới tính",
                  enabled: false,
                  suffixIcon: Icons.arrow_drop_down,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("Cập nhật", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller, {
    String? hintText,
    bool enabled = true,
    Color? fillColor,
    IconData? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: fillColor ?? Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: 20) : null,
        ),
      ),
    );
  }

  void _chonNgaySinh(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        DateTime tempPicked = _selectedDate ?? DateTime(2010, 1, 1);
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text("Chọn ngày sinh", style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempPicked,
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    tempPicked = newDate;
                  },
                  
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = tempPicked;
                    _NgayThangNamSinhController.text = DateFormat('dd/MM/yyyy', 'vi_VN').format(tempPicked);
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  minimumSize: const Size.fromHeight(45),
                ),
                child: const Text("XÁC NHẬN", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hủy bỏ"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _chonGioiTinh(BuildContext context) {
    final List<String> options = ["Nam", "Nữ", "Khác"];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          child: Column(
            children: [
              const Text("Chọn Giới Tính", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(options[index]),
                      onTap: () {
                        setState(() {
                          _gioiTinhController.text = options[index];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  minimumSize: const Size.fromHeight(45),
                ),
                child: const Text("XÁC NHẬN", style: TextStyle(color: Colors.white)),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Hủy bỏ"),
              ),
            ],
          ),
        );
      },
    );
  }
} 
