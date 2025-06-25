import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/ThuongHieuModel.dart';

class ThuongHieuService {
  static const String _baseUrl = "http://10.0.2.2/app_api/ThuongHieu";

  static Future<List<ThuongHieu>> fetchThuongHieu() async {
    final response = await http.get(Uri.parse("$_baseUrl/get_thuonghieu.php"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['status'] == 'success') {
        final List<dynamic> data = jsonData['data'];
        return data.map((item) => ThuongHieu.fromJson(item)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Không thể tải thương hiệu sản phẩm");
    }
  }

  static Future<List<ThuongHieu>> fetchThuongHieuTheoDanhMuc(
    int danhMucId,
  ) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/get_thuonghieu_by_danhmuc.php?danhMucId=$danhMucId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => ThuongHieu.fromJson(e)).toList();
    } else {
      throw Exception('Lỗi khi tải dữ liệu thương hiệu theo danh mục');
    }
  }
}
