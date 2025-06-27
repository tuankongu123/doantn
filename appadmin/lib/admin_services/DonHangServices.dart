import 'dart:convert';
import 'package:appadmin/models/chitiet_donhang_model.dart';
import 'package:appadmin/models/donhang_model.dart';
import 'package:http/http.dart' as http;

class DonHangService {
  static const String baseUrl = "http://localhost/app_api/DonHang/";

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

  static Future<List<DonHang>> fetchDonHang({String? trangThai}) async {
    final url = Uri.parse(
      "http://localhost/app_api/Admin/donhang.php${trangThai != null ? '?trangThai=$trangThai' : ''}",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> list = data['data'];

      return list.map((e) => DonHang.fromJson(e)).toList();
    } else {
      throw Exception("Lỗi khi tải đơn hàng");
    }
  }

  static Future<List<ChiTietDonHang>> fetchChiTiet(int donHangId) async {
    final url = Uri.parse(
      "http://10.0.2.2/app_api/Admin/donhang_chitiet.php?donHangId=$donHangId",
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<ChiTietDonHang>.from(
        data.map((e) => ChiTietDonHang.fromJson(e)),
      );
    } else {
      throw Exception("Lỗi khi tải chi tiết đơn hàng");
    }
  }

  static Future<bool> duyetDon(int id) async {
    final url = Uri.parse("http://10.0.2.2/app_api/Admin/duyet_don.php");
    final response = await http.post(url, body: {"id": id.toString()});

    final result = jsonDecode(response.body);
    return result['status'] == 'success';
  }
}
