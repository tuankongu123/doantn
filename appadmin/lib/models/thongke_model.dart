class ThongKeResponse {
  final int donHomNay;
  final double doanhThu;
  final String sanPhamBanChay;
  final int donChoDuyet;

  ThongKeResponse({
    required this.donHomNay,
    required this.doanhThu,
    required this.sanPhamBanChay,
    required this.donChoDuyet,
  });

  factory ThongKeResponse.fromJson(Map<String, dynamic> json) {
    return ThongKeResponse(
      donHomNay: json['don_hom_nay'] ?? 0,
      doanhThu: (json['doanh_thu'] ?? 0).toDouble(),
      sanPhamBanChay: json['san_pham_ban_chay'] ?? 'Chưa có',
      donChoDuyet: json['don_cho_duyet'] ?? 0,
    );
  }
}
