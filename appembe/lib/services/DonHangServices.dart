import 'dart:convert';
import 'package:appembe/model/chitiet_donhang_model.dart';
import 'package:appembe/model/donhang_model.dart';
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

  static Future<List<DonHang>> fetchDonHang({String? trangThai}) async {
    final url = Uri.parse(
      "http://10.0.2.2/app_api/Admin/donhang.php${trangThai != null ? '?trangThai=$trangThai' : ''}",
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

  Future<List<DonHang>> getDonHangByNguoiDungId(int nguoiDungId) async {
    final response = await http.get(
      Uri.parse(
        "http://10.0.2.2/app_api/DonHang/donhang_user.php?nguoiDungId=$nguoiDungId",
      ),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonBody = json.decode(response.body);
      if (jsonBody['status'] == 'success') {
        final List<dynamic> data = jsonBody['data'];
        return data.map((json) => DonHang.fromJson(json)).toList();
      } else {
        throw Exception("Lỗi từ server: ${jsonBody['message']}");
      }
    } else {
      throw Exception("Lỗi HTTP khi tải đơn hàng");
    }
  }
}
