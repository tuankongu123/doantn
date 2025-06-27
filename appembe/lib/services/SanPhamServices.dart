import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/SanPhamModel.dart';

class SanPhamService {
  static const String baseUrl = "http://10.0.2.2/app_api/SanPham/";
  static Future<List<SanPham>> fetchSanPham() async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2/app_api/SanPham/get_sanpham.php"),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData["data"];
      return data.map((item) => SanPham.fromJson(item)).toList();
    } else {
      throw Exception("Không thể tải danh sách sản phẩm");
    }
  }

  static Future<List<SanPham>> fetchByDanhMucId(int danhMucId) async {
    final url = Uri.parse(
      'http://10.0.2.2/app_api/DanhMuc/get_sanpham_by_danhmuc.php?danhMucId=$danhMucId',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return List<SanPham>.from(
          data['data'].map((item) => SanPham.fromJson(item)),
        );
      }
    }
    return [];
  }

  static Future<List<SanPham>> fetchByThuongHieuId(int thuongHieuId) async {
    final url = Uri.parse(
      'http://10.0.2.2/app_api/SanPham/get_sanpham_by_thuonghieu.php?thuongHieuId=$thuongHieuId',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        return List<SanPham>.from(
          data['data'].map((item) => SanPham.fromJson(item)),
        );
      }
    }
    return [];
  }

  static Future<List<SanPham>> fetchByDanhMucAndThuongHieu(
    int danhMucId,
    int thuongHieuId,
  ) async {
    final response = await http.get(
      Uri.parse(
        'http://10.0.2.2/app_api/SanPham/get_sanpham_by_danhmuc_thuonghieu.php?danhMucId=$danhMucId&thuongHieuId=$thuongHieuId',
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => SanPham.fromJson(e)).toList();
    } else {
      throw Exception('Không thể tải sản phẩm theo danh mục và thương hiệu');
    }
  }

  static Future<void> xoa(int id) async {
    final url = Uri.parse("${baseUrl}delete_sanpham.php?id=$id");

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Xoá sản phẩm thất bại");
    }
  }

  static Future<List<SanPham>> fetchByKeyword(String keyword) async {
    final response = await http.get(
      Uri.parse("$baseUrl/timkiem_sanpham.php?keyword=$keyword"),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == 'success') {
        return (decoded['data'] as List)
            .map((json) => SanPham.fromJson(json))
            .toList();
      } else {
        throw Exception(decoded['message']);
      }
    } else {
      throw Exception("Lỗi kết nối API");
    }
  }
}
