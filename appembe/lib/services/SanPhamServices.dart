import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/SanPhamModel.dart';

class SanPhamService {
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
}
