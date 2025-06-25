import 'dart:convert';
import 'package:http/http.dart' as http;

class BeYeuService {
  static const String _baseUrl = "http://10.0.2.2/app_api/NguoiDung";
  static Future<List<Map<String, dynamic>>> layDanhSachBe(
    int nguoiDungId,
  ) async {
    final url = Uri.parse("$_baseUrl/Lay_Be_Yeu.php?id=$nguoiDungId");

    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return List<Map<String, dynamic>>.from(data['data']);
      } else {
        throw Exception('Không có dữ liệu bé yêu');
      }
    } catch (e) {
      print("❌ Lỗi lấy bé yêu: $e");
      return [];
    }
  }

  static Future<bool> themBeYeu({
    required int nguoiDungId,
    required String tenBe,
    required String ngaySinh,
    required String gioiTinh,
  }) async {
    final url = Uri.parse("$_baseUrl/Them_Be_Yeu.php");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nguoiDungId": 1,
          "tenBe": tenBe,
          "ngaySinh": ngaySinh,
          "gioiTinh": gioiTinh,
        }),
      );

      final jsonData = jsonDecode(response.body);
      return jsonData['success'] == true;
    } catch (e) {
      print("❌ Lỗi thêm bé yêu: $e");
      return false;
    }
  }
}
