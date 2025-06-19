class DanhMuc {
  final int id;
  final String ten;
  final String moTa;

  DanhMuc({required this.id, required this.ten, required this.moTa});

  factory DanhMuc.fromJson(Map<String, dynamic> json) {
    return DanhMuc(
      id: int.parse(json['id'].toString()),
      ten: json['ten'] ?? '',
      moTa: json['moTa'] ?? '',
    );
  }
}
