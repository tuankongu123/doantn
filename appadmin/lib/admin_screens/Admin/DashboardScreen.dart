import 'package:appadmin/admin_screens/Admin/QuanLyDonHangScreen.dart';
import 'package:appadmin/admin_screens/Admin/QuanLyNguoiDungScreen.dart';
import 'package:appadmin/admin_screens/Admin/QuanLySanPham.dart';
import 'package:appadmin/admin_screens/Admin/ThongKeScreen.dart';
import 'package:appadmin/admin_services/thongke_service.dart';
import 'package:appadmin/models/thongke_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: const Color(0xFFF2F4F8),
      appBar: AppBar(
        title: Text(
          "QUẢN LÝ APP",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          constraints: const BoxConstraints(maxWidth: 1000),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tổng quan",
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                FutureBuilder<ThongKeResponse>(
                  future: _thongKeFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Lỗi: \${snapshot.error}');
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
                Text(
                  "Chức năng quản trị",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                _AdminMenuCard(
                  title: "Quản lý sản phẩm",
                  icon: Icons.inventory,
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Admin_QuanLySanPhamScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _AdminMenuCard(
                  title: "Quản lý đơn hàng",
                  icon: Icons.receipt_long,
                  color: Colors.teal,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuanLyDonHangScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _AdminMenuCard(
                  title: "Quản lý người dùng",
                  icon: Icons.people,
                  color: Colors.deepPurple,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const AdminQuanLyNguoiDungScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _AdminMenuCard(
                  title: "Thống kê & Báo cáo",
                  icon: Icons.bar_chart,
                  color: Colors.deepOrange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ThongKeScreen(),
                      ),
                    );
                  },
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
        elevation: 4,
        shadowColor: color.withOpacity(0.3),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 16),
              Text(
                value,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminMenuCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AdminMenuCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
