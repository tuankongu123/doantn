import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/GioHangModel.dart';

class GioHangService {
  static const String baseUrl = "http://10.0.2.2/app_api/GioHang/";

  static Future<List<GioHangItem>> layGioHang(int nguoiDungId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/lay_giohang.php?nguoiDungId=$nguoiDungId"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success") {
        return (data["data"] as List)
            .map((item) => GioHangItem.fromJson(item))
            .toList();
      }
    }
    return [];
  }

  static Future<bool> themVaoGioHang(
    int nguoiDungId,
    int sanPhamId,
    int soLuong,
  ) async {
    final response = await http.post(
      Uri.parse("$baseUrl/them_giohang.php"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "nguoiDungId": nguoiDungId,
        "sanPhamId": sanPhamId,
        "soLuong": soLuong,
      }),
    );

    print('Response: ${response.body}');

    return response.statusCode == 200 &&
        json.decode(response.body)['status'] == 'success';
  }

  static Future<bool> xoaKhoiGioHang(int gioHangId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/xoa_giohang.php"),
      body: json.encode({"gioHangId": gioHangId}),
    );
    return response.statusCode == 200 &&
        json.decode(response.body)['status'] == 'success';
  }

  static Future<bool> capNhatSoLuong(int gioHangId, int soLuong) async {
    final response = await http.post(
      Uri.parse("$baseUrl/capnhat_soluong_giohang.php"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"gioHangId": gioHangId, "soLuong": soLuong}),
    );

    print('Cap nhat: ${response.body}');

    return response.statusCode == 200 &&
        json.decode(response.body)['status'] == 'success';
  }

  static Future<bool> xoaGioHangTheoNguoiDung(int nguoiDungId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/xoa_giohang_theo_nguoidung.php"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"nguoiDungId": nguoiDungId}),
    );

    return response.statusCode == 200 &&
        json.decode(response.body)['status'] == 'success';
  }
}
