class ChiTietDonHang {
  final String tenSanPham;
  final int soLuong;
  final double gia;
  final String diaChi;

  ChiTietDonHang({
    required this.tenSanPham,
    required this.soLuong,
    required this.gia,
    required this.diaChi,
  });

  factory ChiTietDonHang.fromJson(Map<String, dynamic> json) {
    return ChiTietDonHang(
      tenSanPham: json['tenSanPham'] ?? 'Không rõ',
      soLuong: json['soLuong'] ?? 0,
      gia: (json['gia'] != null)
          ? double.tryParse(json['gia'].toString()) ?? 0.0
          : 0.0,
      diaChi: json['diaChi'] ?? 'Không rõ',
    );
  }
}
