class NguoiDung {
  final int id;
  final String firebaseUid;
  final String? hoTen;
  final String? soDienThoai;
  final String? gioiTinh;
  final String? email;
  final DateTime? ngaySinh;
  final String vaiTro;
  final bool xacThuc;
  final DateTime ngayTao;

  NguoiDung({
    required this.id,
    required this.firebaseUid,
    this.hoTen,
    this.soDienThoai,
    this.gioiTinh,
    this.email,
    this.ngaySinh,
    required this.vaiTro,
    required this.xacThuc,
    required this.ngayTao,
  });

  factory NguoiDung.fromJson(Map<String, dynamic> json) {
    return NguoiDung(
      id: json['id'],
      firebaseUid: json['firebaseUid'],
      hoTen: json['hoTen'],
      soDienThoai: json['soDienThoai'],
      gioiTinh: json['gioiTinh'],
      email: json['email'],
      ngaySinh: json['ngaySinh'] != null && json['ngaySinh'] != ''
          ? DateTime.tryParse(json['ngaySinh'])
          : null,
      vaiTro: json['vaiTro'],
      xacThuc: json['xacThuc'] == 1 || json['xacThuc'] == true,
      ngayTao: DateTime.parse(json['ngayTao']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "firebaseUid": firebaseUid,
      "hoTen": hoTen,
      "soDienThoai": soDienThoai,
      "gioiTinh": gioiTinh,
      "email": email,
      "ngaySinh": ngaySinh?.toIso8601String(),
      "vaiTro": vaiTro,
      "xacThuc": xacThuc ? 1 : 0,
      "ngayTao": ngayTao.toIso8601String(),
    };
  }
}
