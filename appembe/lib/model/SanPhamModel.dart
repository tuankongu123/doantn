class SanPham {
  final int id;
  final String ten;
  final double gia;
  final String hinhAnh;
  final int soLuong;
  final String moTa;
  final String danhMuc;
  final String loai;
  final String thuongHieu;

  SanPham({
    required this.id,
    required this.ten,
    required this.gia,
    required this.hinhAnh,
    required this.soLuong,
    required this.moTa,
    required this.danhMuc,
    required this.loai,
    required this.thuongHieu,
  });

  factory SanPham.fromJson(Map<String, dynamic> json) {
    return SanPham(
      id: int.parse(json['id'].toString()),
      ten: json['ten'] ?? '',
      gia: double.tryParse(json['gia'].toString()) ?? 0.0,
      hinhAnh: json['hinhAnh'] ?? '',
      soLuong: int.tryParse(json['soLuong'].toString()) ?? 0,
      moTa: json['moTa'] ?? '',
      danhMuc: json['danhMuc'] ?? '',
      loai: json['loai'] ?? '',
      thuongHieu: json['thuongHieu'] ?? '',
    );
  }
}
