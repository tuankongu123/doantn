import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/DanhMucModel.dart';

class DanhMucService {
  static const String _baseUrl = "http://localhost/app_api/DanhMuc";

  static Future<List<DanhMuc>> fetchDanhMuc() async {
    final response = await http.get(Uri.parse("$_baseUrl/get_danhmuc.php"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      if (jsonData['status'] == 'success') {
        final List<dynamic> data = jsonData['data'];
        return data.map((item) => DanhMuc.fromJson(item)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Không thể tải danh mục sản phẩm");
    }
  }
}
