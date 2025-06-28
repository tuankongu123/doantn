import 'dart:convert';
import 'package:http/http.dart' as http;

class DiaChiService {
  static const String _baseUrl = "http://10.0.2.2/app_api/DiaChi";

  // 📌 Lấy danh sách địa chỉ theo người dùng
  static Future<List<Map<String, dynamic>>> getDiaChi(int nguoiDungId) async {
    final url = Uri.parse("$_baseUrl/Lay_Dia_Chi.php?id=$nguoiDungId");

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception(data['error'] ?? 'Lỗi lấy danh sách địa chỉ');
      }
    } catch (e) {
      print("❌ Lỗi khi lấy địa chỉ: $e");
      rethrow;
    }
  }

  // 📌 Thêm địa chỉ mới
  static Future<bool> themDiaChi({
    required int nguoiDungId,
    required String tenNguoiNhan,
    required String soDienThoai,
    required String diaChi,
  }) async {
    final url = Uri.parse("$_baseUrl/Them_Dia_Chi.php");
    final payload = {
      "nguoiDungId": nguoiDungId,
      "tenNguoiNhan": tenNguoiNhan,
      "soDienThoai": soDienThoai,
      "diaChi": diaChi,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);
      print("📥 Phản hồi từ server: $data");

      return data['success'] == true;
    } catch (e) {
      print("❌ Lỗi thêm địa chỉ: $e");
      return false;
    }
  }

  // static Future<bool> _capNhatDiaChi({
  //   required int id,
  //   required String tenNguoiNhan,
  //   required String soDienThoai,
  //   required String diaChi,
  // }) async {
  //   final response = await http.post(
  //     Uri.parse('http://10.0.2.2/app_api/DiaChi/Them_Dia_Chi.php'),
  //     body: {
  //       'id': id.toString(),
  //       'tenNguoiNhan': tenNguoiNhan,
  //       'soDienThoai': soDienThoai,
  //       'diaChi': diaChi,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     return response.body == 'thanh_cong';
  //   } else {
  //     return false;
  //   }
  // }

  static Future<bool> xoaDiaChi(String id) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/app_api/DiaChi/Them_Dia_Chi.php"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"action": "xoa", "id": int.parse(id)}),
      );

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      print("Lỗi xóa địa chỉ: $e");
      return false;
    }
  }

  static Future<void> datMacDinh(int idDiaChi) async {
    try {
      // Gọi API để cập nhật địa chỉ mặc định
      final response = await http.post(
        Uri.parse('$_baseUrl/diachi/set-default'),
        body: {'id': idDiaChi.toString()},
      );

      if (response.statusCode != 200) {
        throw Exception('Lỗi khi đặt địa chỉ mặc định');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: ${e.toString()}');
    }
  }
  static Future<List<Map<String, dynamic>>> layDanhSachDiaChi() async {
  final url = Uri.parse("$_baseUrl/LayTatCa_Dia_Chi.php");

  try {
    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success'] == true) {
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception(data['error'] ?? 'Lỗi lấy danh sách địa chỉ');
    }
  } catch (e) {
    print("❌ Lỗi khi lấy danh sách địa chỉ: $e");
    rethrow;
  }
}
}
