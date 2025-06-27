import 'package:appadmin/admin_screens/Admin/QuanLyDonHangScreen.dart';
import 'package:appadmin/admin_screens/Admin/QuanLySanPham.dart';
import 'package:appadmin/admin_services/thongke_service.dart';
import 'package:appadmin/models/thongke_model.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  late Future<ThongKeResponse> _thongKeFuture;

  @override
  void initState() {
    super.initState();
    _thongKeFuture = ThongKeService.fetchThongKeDashboard();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Quản trị")),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          constraints: const BoxConstraints(maxWidth: 1000),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Tổng quan",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                FutureBuilder<ThongKeResponse>(
                  future: _thongKeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Lỗi: ${snapshot.error}');
                    } else if (!snapshot.hasData) {
                      return const Text('Không có dữ liệu');
                    }

                    final data = snapshot.data!;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _DashboardCard(
                          title: "Đơn hôm nay",
                          value: data.donHomNay.toString(),
                          icon: Icons.shopping_cart,
                          color: Colors.orange,
                        ),
                        _DashboardCard(
                          title: "Doanh thu hôm nay",
                          value: "${data.doanhThu.toStringAsFixed(0)}đ",
                          icon: Icons.attach_money,
                          color: Colors.green,
                        ),
                        _DashboardCard(
                          title: "Sản phẩm bán chạy",
                          value: data.sanPhamBanChay,
                          icon: Icons.trending_up,
                          color: Colors.blue,
                        ),
                        _DashboardCard(
                          title: "Đơn chờ duyệt",
                          value: data.donChoDuyet.toString(),
                          icon: Icons.access_time,
                          color: Colors.red,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 40),
                const Text(
                  "Chức năng quản trị",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.inventory),
                    title: const Text("Quản lý sản phẩm"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const Admin_QuanLySanPhamScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: const Text("Quản lý đơn hàng"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuanLyDonHangScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text("Quản lý người dùng"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(title, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
