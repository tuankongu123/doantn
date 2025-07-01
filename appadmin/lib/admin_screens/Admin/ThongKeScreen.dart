import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ThongKeScreen extends StatefulWidget {
  const ThongKeScreen({super.key});

  @override
  State<ThongKeScreen> createState() => _ThongKeScreenState();
}

class _ThongKeScreenState extends State<ThongKeScreen> {
  double doanhThu = 0;
  List<Map<String, dynamic>> sanPhamBanChay = [];
  List<Map<String, dynamic>> donHangTrangThai = [];
  List<Map<String, dynamic>> tonKhoDanhMuc = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final d1 = await http.get(
      Uri.parse(
        "http://localhost/app_api/thongke/tong_doanh_thu.php?type=today",
      ),
    );
    final d2 = await http.get(
      Uri.parse("http://localhost/app_api/thongke/sanpham_banchay.php"),
    );
    final d3 = await http.get(
      Uri.parse("http://localhost/app_api/thongke/donhang_theo_trangthai.php"),
    );
    final d4 = await http.get(
      Uri.parse("http://localhost/app_api/thongke/tonkho_theo_danhmuc.php"),
    );

    setState(() {
      doanhThu = json.decode(d1.body)['doanhThu'] ?? 0;
      sanPhamBanChay = List<Map<String, dynamic>>.from(json.decode(d2.body));
      donHangTrangThai = List<Map<String, dynamic>>.from(json.decode(d3.body));
      tonKhoDanhMuc = List<Map<String, dynamic>>.from(json.decode(d4.body));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Báo cáo thống kê")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoanhThuCard(),
            const SizedBox(height: 12),
            _buildTopSanPham(),
            const SizedBox(height: 12),
            _buildTrangThaiDonHangChart(),
            const SizedBox(height: 12),
            _buildTonKhoDanhMucChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildDoanhThuCard() {
    return Card(
      child: ListTile(
        title: const Text("Tổng doanh thu hôm nay"),
        subtitle: Text(
          "${doanhThu.toStringAsFixed(0)} đ",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        leading: const Icon(Icons.bar_chart, color: Colors.green),
      ),
    );
  }

  Widget _buildTopSanPham() {
    return Card(
      child: Column(
        children: [
          const ListTile(title: Text("Top 5 sản phẩm bán chạy nhất")),
          ...sanPhamBanChay.map(
            (e) => ListTile(
              title: Text(e['ten']),
              trailing: Text("SL: ${e['tongSoLuong']}"),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrangThaiDonHangChart() {
    return Card(
      child: Column(
        children: [
          const ListTile(title: Text("Đơn hàng theo trạng thái")),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: donHangTrangThai
                    .map(
                      (e) => PieChartSectionData(
                        value: (e['soLuong'] as int).toDouble(),
                        title: e['trangThai'],
                        color: _colorFromTrangThai(e['trangThai']),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTonKhoDanhMucChart() {
    return Card(
      child: Column(
        children: [
          const ListTile(title: Text("Tồn kho theo danh mục")),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                barGroups: tonKhoDanhMuc
                    .asMap()
                    .entries
                    .map(
                      (e) => BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: double.parse(
                              e.value['tongSoLuong'].toString(),
                            ),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    )
                    .toList(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final label = tonKhoDanhMuc[value.toInt()]['danhMuc'];
                        return Text(
                          label,
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _colorFromTrangThai(String? trangThai) {
    switch (trangThai) {
      case 'cho_duyet':
        return Colors.orange;
      case 'da_duyet':
        return Colors.green;
      case 'dang_giao':
        return Colors.blue;
      case 'da_xong':
        return Colors.grey;
      case 'huy':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}
