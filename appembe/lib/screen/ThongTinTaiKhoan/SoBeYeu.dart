import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appembe/model/SoBeModel.dart';

class SoBeYeuScreen extends StatefulWidget {
  @override
  _SoBeYeuScreenState createState() => _SoBeYeuScreenState();
}

class _SoBeYeuScreenState extends State<SoBeYeuScreen> {
  List<hosobe> danhSachBe = [];
  bool _dangTai = false;

  Future<void> fetchBeYeu() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2/app_api/NguoiDung/Lay_Be_Yeu.php?nguoiDungId=1'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          danhSachBe = data.map((e) => hosobe.fromJson(e)).toList();
        });
      } else {
        throw Exception('Lỗi server: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải dữ liệu: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _taiDanhSach();
  }

  Future<void> _taiDanhSach() async {
    setState(() => _dangTai = true);
    await fetchBeYeu();
    setState(() => _dangTai = false);
  }

  String _tinhTuoi(String ngaySinhStr) {
    try {
      final ngaySinh = DateTime.parse(ngaySinhStr);
      final now = DateTime.now();
      final tuoiThang = (now.year - ngaySinh.year) * 12 + (now.month - ngaySinh.month);
      if (tuoiThang < 12) {
        return '$tuoiThang tháng tuổi';
      } else {
        final tuoiNam = tuoiThang ~/ 12;
        return '$tuoiNam tuổi';
      }
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thông tin Bé Yêu')),
      body: Column(
        children: [
          Expanded(
            child: _dangTai
                ? Center(child: CircularProgressIndicator())
                : danhSachBe.isEmpty
                    ? Center(child: Text('Chưa có bé yêu nào.'))
                    : ListView.builder(
                        itemCount: danhSachBe.length,
                        itemBuilder: (context, index) {
                          final be = danhSachBe[index];
                          return Card(
                            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              title: Text('${be.tenBe} (${_tinhTuoi(be.ngaySinh)})'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Ngày sinh: ${be.ngaySinh}'),
                                  Text('Giới tính: ${be.gioiTinh}'),
                                  Text('Cân nặng: ${be.canNang} kg'),
                                  
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            child: Text('Thêm Thông Tin Bé Yêu'),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ThemBeYeuScreen()),
              );
              if (result == true) _taiDanhSach();
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}


class ThemBeYeuScreen extends StatefulWidget {
  @override
  _ThemBeYeuScreenState createState() => _ThemBeYeuScreenState();
}

class _ThemBeYeuScreenState extends State<ThemBeYeuScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tenBeController = TextEditingController();
  final TextEditingController _canNangController = TextEditingController();
  final TextEditingController _nhomMauController = TextEditingController();
  DateTime? _selectedDate;
  String _gioiTinh = 'Nam';
  bool _dangLuu = false;

  Future<void> _chonNgaySinh(BuildContext context) async {
    DateTime initialDate = _selectedDate ?? DateTime(2020);
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: 300,
        child: Column(
          children: [
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: initialDate,
                minimumDate: DateTime(2010),
                maximumDate: DateTime.now(),
                onDateTimeChanged: (DateTime newDate) {
                  setState(() {
                    _selectedDate = newDate;
                  });
                },
              ),
            ),
            TextButton(
              child: Text('XÁC NHẬN'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _luuThongTin() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    setState(() => _dangLuu = true);

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2/app_api/NguoiDung/Them_Be_Yeu.php'),
        body: {
          'nguoiDungId': '1',
          'tenBe': _tenBeController.text.trim(),
          'ngaySinh': _selectedDate!.toIso8601String().split('T')[0],
          'gioiTinh': _gioiTinh,
          'canNang': _canNangController.text.trim(),
          'nhomMau': _nhomMauController.text.trim(),
        },
      );

      if (response.statusCode == 200 && response.body.trim() == 'success') {
        Navigator.pop(context, true);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi thêm bé: $e')),
      );
    } finally {
      setState(() => _dangLuu = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm Bé Yêu')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tenBeController,
                decoration: InputDecoration(labelText: 'Tên bé'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập tên' : null,
              ),
              SizedBox(height: 12),
              ListTile(
                title: Text(_selectedDate == null
                    ? 'Chọn ngày sinh'
                    : 'Ngày sinh: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () => _chonNgaySinh(context),
              ),
              SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _gioiTinh,
                items: ['Nam', 'Nữ']
                    .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                    .toList(),
                onChanged: (value) => setState(() => _gioiTinh = value!),
                decoration: InputDecoration(labelText: 'Giới tính'),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _canNangController,
                decoration: InputDecoration(labelText: 'Cân nặng (kg)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Vui lòng nhập cân nặng';
                  final weight = double.tryParse(value);
                  if (weight == null || weight <= 0) return 'Cân nặng không hợp lệ';
                  return null;
                },
              ),
              SizedBox(height: 12),
             
              SizedBox(height: 20),
              _dangLuu
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _luuThongTin,
                      child: Text('Lưu'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
