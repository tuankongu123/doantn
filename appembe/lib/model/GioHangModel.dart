class GioHangItem {
  final int id;
  final int sanPhamId;
  final String tenSanPham;
  final String hinhAnh;
  final int soLuong;
  final double gia;

  GioHangItem({
    required this.id,
    required this.sanPhamId,
    required this.tenSanPham,
    required this.hinhAnh,
    required this.soLuong,
    required this.gia,
  });

  factory GioHangItem.fromJson(Map<String, dynamic> json) {
    return GioHangItem(
      id: json['id'],
      sanPhamId: json['sanPhamId'],
      tenSanPham: json['tenSanPham'],
      hinhAnh: json['hinhAnh'],
      soLuong: json['soLuong'],
      gia: double.parse(json['gia'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sanPhamId': sanPhamId,
      'tenSanPham': tenSanPham,
      'hinhAnh': hinhAnh,
      'soLuong': soLuong,
      'gia': gia,
    };
  }

  Map<String, dynamic> toOrderJson() {
    return {
      'sanPhamId': sanPhamId,
      'tenSanPham': tenSanPham,
      'gia': gia,
      'soLuong': soLuong,
    };
  }
}
