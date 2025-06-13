// import 'dart:convert';

// class DiaChi {
//   final String ten;
//   final String soDienThoai;
//   final String diaChi;
//   final bool macDinh;
//   final String loai;

//   DiaChi({
//     required this.ten,
//     required this.soDienThoai,
//     required this.diaChi,
//     required this.macDinh,
//     required this.loai,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'ten': ten,
//       'soDienThoai': soDienThoai,
//       'diaChi': diaChi,
//       'macDinh': macDinh,
//       'loai': loai,
//     };
//   }

//   factory DiaChi.fromMap(Map<String, dynamic> map) {
//     return DiaChi(
//       ten: map['ten'],
//       soDienThoai: map['soDienThoai'],
//       diaChi: map['diaChi'],
//       macDinh: map['macDinh'],
//       loai: map['loai'],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory DiaChi.fromJson(String source) => DiaChi.fromMap(json.decode(source));
// }
