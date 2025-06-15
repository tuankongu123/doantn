import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/GioHangModel.dart';

class GioHangService {
  static const String _baseUrl = "http://10.0.2.2/app_api/GioHang";

  /// Lấy danh sách sản phẩm trong giỏ hàng theo người dùng
  static Future<List<GioHangItem>> fetchGioHang(int nguoiDungId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/lay_giohang.php?nguoiDungId=$nguoiDungId"),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData["status"] == "success") {
        return (jsonData["data"] as List)
            .map((item) => GioHangItem.fromJson(item))
            .toList();
      } else {
        throw Exception("Dữ liệu trả về không thành công");
      }
    } else {
      throw Exception("Lỗi khi tải giỏ hàng");
    }
  }

  /// Thêm sản phẩm vào giỏ hàng
  static Future<bool> themVaoGioHang({
    required int nguoiDungId,
    required int sanPhamId,
    required int soLuong,
  }) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/them_giohang.php"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "nguoiDungId": nguoiDungId,
        "sanPhamId": sanPhamId,
        "soLuong": soLuong,
      }),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData["status"] == "success";
    } else {
      return false;
    }
  }
}
