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
      id: int.parse(json['id'].toString()),
      nguoiDungId: int.parse(json['nguoiDungId'].toString()),
      tenNguoiNhan: json['tenNguoiNhan'],
      soDienThoai: json['soDienThoai'],
      diaChi: json['diaChi'],
    );
  }
}
