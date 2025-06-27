class ThuongHieu {
  final int id;
  final String ten;

  ThuongHieu({required this.id, required this.ten});

  factory ThuongHieu.fromJson(Map<String, dynamic> json) {
    return ThuongHieu(
      id: int.parse(json['id'].toString()),
      ten: json['ten'] ?? '',
    );
  }
}
