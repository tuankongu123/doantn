class SanPham {
  final int id;
  final String ten;
  final String hinhAnh;
  final double gia;
  final String moTa;
  final String danhMuc;
  final String loai;
  final String thuonghieu;

  SanPham({
    required this.id,
    required this.ten,
    required this.hinhAnh,
    required this.gia,
    required this.moTa,
    required this.danhMuc,
    required this.loai,
    required this.thuonghieu,
  });

  factory SanPham.fromJson(Map<String, dynamic> json) {
    return SanPham(
      id: int.parse(json['id']),
      ten: json['ten'],
      hinhAnh: json['hinhAnh'],
      gia: double.parse(json['gia'].toString()),
      moTa: json['moTa'] ?? '',
      danhMuc: json['danhMuc'] ?? '',
      loai: json['loai'] ?? '',
      thuonghieu: json['thuonghieu'] ?? '',
    );
  }
}
