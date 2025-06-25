import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:appembe/model/NguoiDungModel.dart';
import 'package:appembe/services/NguoiDungService.dart';

class ThongTinCaNhanScreen extends StatefulWidget {
  const ThongTinCaNhanScreen({super.key});

  @override
  State<ThongTinCaNhanScreen> createState() => _ThongTinCaNhanScreenState();
}

class _ThongTinCaNhanScreenState extends State<ThongTinCaNhanScreen> {
  final TextEditingController _tenController = TextEditingController();
  final TextEditingController _sdtController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ngaySinhController = TextEditingController();
  final TextEditingController _gioiTinhController = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = true;
  bool _ngaySinhDaTonTai = false;

  late NguoiDung _nguoiDung;

  @override
  void initState() {
    super.initState();
    _taiThongTinNguoiDung();
  }

  Future<void> _taiThongTinNguoiDung() async {
    const int id = 1;

    final nguoiDung = await NguoiDungService.layThongTinNguoiDung(id);

    if (nguoiDung != null) {
      setState(() {
        _nguoiDung = nguoiDung;
        _tenController.text = nguoiDung.hoTen ?? '';
        _sdtController.text = nguoiDung.soDienThoai ?? '';
        _emailController.text = nguoiDung.email ?? '';
        _gioiTinhController.text = nguoiDung.gioiTinh ?? '';

        if (nguoiDung.ngaySinh != null) {
          _selectedDate = nguoiDung.ngaySinh;
          _ngaySinhController.text = DateFormat(
            'dd/MM/yyyy',
          ).format(_selectedDate!);
          _ngaySinhDaTonTai = true;
        }

        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❗Không tìm thấy người dùng")),
      );
    }
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                  _buildTextField(_emailController, hintText: "Email liên lạc"),
                  GestureDetector(
                    onTap: () => _chonNgaySinh(context),
                    child: AbsorbPointer(
                      child: _buildTextField(
                        _ngaySinhController,
                        hintText: "Ngày sinh",
                        enabled: false,
                        suffixIcon: Icons.calendar_today,
                      ),
                    ),
                  ),
                  if (_ngaySinhDaTonTai)
                    const Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 8),
                      child: Text(
                        "🎂 Ngày sinh chỉ được nhập 1 lần để nhận ưu đãi",
                        style: TextStyle(color: Colors.redAccent, fontSize: 12),
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
                    onPressed: _capNhatThongTin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      "Cập nhật",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _capNhatThongTin() async {
    final nguoiDungCapNhat = NguoiDung(
      id: _nguoiDung.id,
      firebaseUid: _nguoiDung.firebaseUid,
      hoTen: _tenController.text.trim(),
      soDienThoai: _sdtController.text.trim(),
      email: _emailController.text.trim(),
      gioiTinh: _gioiTinhController.text.trim(),
      ngaySinh: _nguoiDung.ngaySinh ?? _selectedDate,
      vaiTro: _nguoiDung.vaiTro,
      xacThuc: _nguoiDung.xacThuc,
      ngayTao: _nguoiDung.ngayTao,
    );

    final thanhCong = await NguoiDungService.capNhatThongTinNguoiDung(
      nguoiDungCapNhat,
    );

    if (thanhCong) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("✅ Cập nhật thành công")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Cập nhật thất bại")));
    }
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
    if (_ngaySinhDaTonTai) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "🎂 Ngày sinh chỉ được cập nhật 1 lần và không thể thay đổi.",
          ),
        ),
      );
      return;
    }

    DateTime tempPicked = _selectedDate ?? DateTime(2010, 1, 1);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Chọn ngày sinh",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: tempPicked,
                  maximumDate: DateTime.now(),
                  onDateTimeChanged: (newDate) => tempPicked = newDate,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = tempPicked;
                    _ngaySinhController.text = DateFormat(
                      'dd/MM/yyyy',
                    ).format(tempPicked);
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  "XÁC NHẬN",
                  style: TextStyle(color: Colors.white),
                ),
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
    final List<String> options = ["Nam", "Nữ"];

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
              const Text(
                "Chọn Giới Tính",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
                child: const Text(
                  "XÁC NHẬN",
                  style: TextStyle(color: Colors.white),
                ),
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
