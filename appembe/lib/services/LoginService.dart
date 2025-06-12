import 'package:http/http.dart' as http;

class AuthService {
  static Future<String> login(String phone, String password) async {
    try {
      final url = Uri.parse("http://your-server.com/api/login.php");
      final response = await http.post(
        url,
        body: {'phone': phone, 'password': password},
      );

      if (response.statusCode == 200) {
        if (response.body.contains("success")) {
          return "Đăng nhập thành công";
        } else {
          return "Sai số điện thoại hoặc mật khẩu";
        }
      } else {
        return "Lỗi máy chủ: ${response.statusCode}";
      }
    } catch (e) {
      return "Lỗi kết nối: $e";
    }
  }
}
