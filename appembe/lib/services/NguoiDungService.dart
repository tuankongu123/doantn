import 'dart:convert';
import 'package:appembe/model/NguoiDungModel.dart';
import 'package:http/http.dart' as http;

class NguoiDungService {
  static const String _baseUrl = "http://10.0.2.2/app_api/otp";

  static Future<int?> layHoacTaoNguoiDungId(
    String firebaseUid,
    String soDienThoai,
  ) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/lay_or_tao_id_nguoidung.php"),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "firebaseUid": firebaseUid,
        "soDienThoai": soDienThoai,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data["status"] == "success" || data["status"] == "created") {
        return data["id"];
      }
    }
    return null;
  }

  static Future<NguoiDung?> layThongTinNguoiDung(int id) async {
    final response = await http.get(
      Uri.parse(
        "http://10.0.2.2/app_api/NguoiDung/lay_thongtin_nguoidung.php?id=$id",
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData["status"] == "success") {
        return NguoiDung.fromJson(jsonData["data"]);
      }
    }
    return null;
  }

  static Future<bool> capNhatThongTinNguoiDung(NguoiDung nguoiDung) async {
    final response = await http.post(
      Uri.parse(
        "http://10.0.2.2/app_api/NguoiDung/capnhat_thongtin_nguoidung.php",
      ),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(nguoiDung.toJson()),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData["status"] == "success";
    }
    return false;
  }
}
