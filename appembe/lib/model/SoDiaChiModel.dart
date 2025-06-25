class SoDiaChi {
  final int id;
  final int nguoiDungId;
  final String tenNguoiNhan;
  final String soDienThoai;
  final String diaChi;

  SoDiaChi({
    required this.id,
    required this.nguoiDungId,
    required this.tenNguoiNhan,
    required this.soDienThoai,
    required this.diaChi,
  });

  factory SoDiaChi.fromJson(Map<String, dynamic> json) {
    return SoDiaChi(
      id: json['id'],
      nguoiDungId: json['nguoiDungId'],
      tenNguoiNhan: json['tenNguoiNhan'],
      soDienThoai: json['soDienThoai'],
      diaChi: json['diaChi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nguoiDungId': nguoiDungId,
      'tenNguoiNhan': tenNguoiNhan,
      'soDienThoai': soDienThoai,
      'diaChi': diaChi,
    };
  }
}
