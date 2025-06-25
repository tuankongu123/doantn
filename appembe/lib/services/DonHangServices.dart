import 'dart:convert';
import 'package:http/http.dart' as http;

class DonHangService {
  static const String baseUrl = "http://10.0.2.2/app_api/DonHang/";

  static Future<bool> taoDonHang({
    required int nguoiDungId,
    required String phuongThucTt,
    required List<Map<String, dynamic>> danhSachSanPham,
  }) async {
    final response = await http.post(
      Uri.parse("${baseUrl}tao_donhang.php"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "nguoiDungId": nguoiDungId,
        "phuongThucTt": phuongThucTt,
        "danhSachSanPham": danhSachSanPham,
      }),
    );

    final data = json.decode(response.body);
    return response.statusCode == 200 && data['status'] == 'success';
  }
}
