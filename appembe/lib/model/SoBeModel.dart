class hosobe {
  final int id;
  final String tenBe;
  final String ngaySinh;
  final String gioiTinh;
  final int canNang;

  hosobe({
    required this.id,
    required this.tenBe,
    required this.ngaySinh,
    required this.gioiTinh,
    required this.canNang,
  });

  factory hosobe.fromJson(Map<String, dynamic> json) {
    return hosobe(
      id: int.parse(json['id'].toString()),
      tenBe: json['tenBe'] ?? '',
      ngaySinh: json['ngaySinh'] ?? '',
      gioiTinh: json['gioiTinh'] ?? '',
      canNang: json['CanNang'] == null ? 0 : int.tryParse(json['CanNang'].toString()) ?? 0,
    );
  }
}
