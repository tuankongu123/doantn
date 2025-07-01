import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/nguoi_dung_model.dart';

class NguoiDungService {
  static const String baseUrl =
      "http://localhost/app_api/Admin/QuanLyNguoiDung";

  static Future<List<NguoiDung>> fetchAll() async {
    final res = await http.get(Uri.parse("$baseUrl/lay_danh_sach.php"));
    final data = jsonDecode(res.body);
    if (data['status'] == 'success') {
      return (data['data'] as List).map((e) => NguoiDung.fromJson(e)).toList();
    } else {
      throw Exception("Không lấy được danh sách người dùng");
    }
  }

  static Future<void> capNhatVaiTro(int id, String vaiTro) async {
    await http.post(
      Uri.parse("$baseUrl/phan_quyen.php"),
      body: {'id': id.toString(), 'vaiTro': vaiTro},
    );
  }

  static Future<void> capNhatXacThuc(int id, bool trangThai) async {
    await http.post(
      Uri.parse("$baseUrl/cap_nhat_trang_thai.php"),
      body: {'id': id.toString(), 'xacThuc': trangThai ? '1' : '0'},
    );
  }
}
