import 'package:appembe/services/BeYeuService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ThemBeYeuScreen extends StatefulWidget {
  const ThemBeYeuScreen({super.key});

  @override
  State<ThemBeYeuScreen> createState() => _ThemBeYeuScreenState();
}

class _ThemBeYeuScreenState extends State<ThemBeYeuScreen> {
  final TextEditingController _tenBeController = TextEditingController();
  DateTime? _ngaySinh;
  String? _gioiTinh;

  final int nguoiDungId = 1; // ⚠️ mặc định test

  final _formKey = GlobalKey<FormState>();

  Future<void> _chonNgaySinh() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2020),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _ngaySinh = picked;
      });
    }
  }

  void _luuBeYeu() async {
    if (!_formKey.currentState!.validate() ||
        _ngaySinh == null ||
        _gioiTinh == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đầy đủ thông tin")),
      );
      return;
    }

    final success = await BeYeuService.themBeYeu(
      nguoiDungId: nguoiDungId,
      tenBe: _tenBeController.text.trim(),
      ngaySinh: DateFormat('yyyy-MM-dd').format(_ngaySinh!),
      gioiTinh: _gioiTinh!,
    );

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Thêm thất bại")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Thông tin Bé Yêu")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Vui lòng cho biết Ngày sinh của bé"),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tenBeController,
                decoration: const InputDecoration(
                  hintText: "Họ tên của bé",
                  filled: true,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Vui lòng nhập đầy đủ họ tên của bé"
                    : null,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _chonNgaySinh,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _ngaySinh != null
                            ? DateFormat('dd/MM/yyyy').format(_ngaySinh!)
                            : 'Chọn ngày sinh',
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                hint: const Text("Chọn giới tính"),
                items: const [
                  DropdownMenuItem(value: 'Nam', child: Text("Bé trai")),
                  DropdownMenuItem(value: 'Nữ', child: Text("Bé gái")),
                ],
                onChanged: (value) => setState(() => _gioiTinh = value),
                validator: (value) =>
                    value == null ? "Vui lòng chọn giới tính" : null,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _luuBeYeu,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Cập nhật", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
