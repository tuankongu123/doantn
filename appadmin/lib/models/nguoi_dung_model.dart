class NguoiDung {
  final int id;
  final String hoTen;
  final String? hinhAnh;
  final String soDienThoai;
  final String? email;
  String vaiTro; // ← bỏ final
  bool xacThuc; // ← bỏ final

  NguoiDung({
    required this.id,
    required this.hoTen,
    this.hinhAnh,
    required this.soDienThoai,
    this.email,
    required this.vaiTro,
    required this.xacThuc,
  });

  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      id: int.parse(json['id'].toString()),
      hoTen: json['hoTen'] ?? '',
      hinhAnh: json['hinhAnh'],
      soDienThoai: json['soDienThoai'] ?? '',
      email: json['email'],
      vaiTro: json['vaiTro'],
      xacThuc: json['xacThuc'].toString() == '1',
    );
  }
}
