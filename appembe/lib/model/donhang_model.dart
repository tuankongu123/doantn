class DonHang {
  final int id;
  final String tenNguoiDung;
  final String ngayTao;
  final String trangThai;
  final double tongTien;

  DonHang({
    required this.id,
    required this.tenNguoiDung,
    required this.ngayTao,
    required this.trangThai,
    required this.tongTien,
  });

  factory DonHang.fromJson(Map<String, dynamic> json) {
    return DonHang(
      id: json['id'] ?? 0,
      tenNguoiDung:
          json['tenNguoiDung'] ??
          json['hoTen'] ??
          'Không rõ', // fallback nếu không có trường này
      ngayTao: json['ngayTao'] ?? '',
      trangThai: json['trangThai'] ?? '',
      tongTien: (json['tongTien'] != null)
          ? double.tryParse(json['tongTien'].toString()) ?? 0.0
          : 0.0,
    );
  }
}
