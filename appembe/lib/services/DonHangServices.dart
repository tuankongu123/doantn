import 'dart:convert';
import 'package:http/http.dart' as http;

class DonHangServices {
  static Future<http.Response> taoDonHang({
    required List<Map<String, dynamic>> danhSachSanPham,
    required double tongTien,
    required String phuongThucTt,
    required int diaChiId,
    required Map<String, dynamic> diaChiChiTiet, // ✅ Địa chỉ chi tiết
  }) async {
    final url = Uri.parse('http://10.0.2.2/app_api/DonHang/tao_don_hang.php');

    final body = jsonEncode({
      'danhSachSanPham': danhSachSanPham,
      'tongTien': tongTien,
      'phuongThucTt': phuongThucTt,
      'diaChiId': diaChiId,
      'diaChiChiTiet': diaChiChiTiet, // ✅ gửi chi tiết địa chỉ
    });

    print("========== GỬI ĐƠN HÀNG ==========");
    print("➡ URL: \$url");
    print("➡ BODY: \$body");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    print("⬅ STATUS: \${response.statusCode}");
    print("⬅ BODY: \${response.body}");

    return response;
  }
}
