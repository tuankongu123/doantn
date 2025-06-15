class GioHangItem {
  final int id;
  final String ten;
  final String hinhAnh;
  final double gia;
  final int soLuong;

  GioHangItem({
    required this.id,
    required this.ten,
    required this.hinhAnh,
    required this.gia,
    required this.soLuong,
  });

  factory GioHangItem.fromJson(Map<String, dynamic> json) {
    return GioHangItem(
      id: json['id'],
      ten: json['ten'],
      hinhAnh: json['hinhAnh'],
      gia: double.parse(json['gia'].toString()),
      soLuong: json['soLuong'],
    );
  }

  double get thanhTien => gia * soLuong;
}
