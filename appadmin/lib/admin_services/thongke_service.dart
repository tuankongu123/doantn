import 'dart:convert';

import 'package:appadmin/models/thongke_model.dart';
import 'package:http/http.dart' as http;

class ThongKeService {
  static const String _baseUrl = "http://localhost/app_api/Admin";

  static Future<ThongKeResponse> fetchThongKeDashboard() async {
    final url = Uri.parse("$_baseUrl/dashboard_summary.php");
    final response = await http.get(url);

    // In response để debug
    print("Raw response: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == 'success') {
        return ThongKeResponse.fromJson(decoded['data']);
      } else {
        throw Exception(decoded['message'] ?? 'Lỗi không xác định từ API');
      }
    } else {
      throw Exception('Lỗi kết nối API: ${response.statusCode}');
    }
  }
}
