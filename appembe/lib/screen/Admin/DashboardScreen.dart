import 'package:appembe/screen/Admin/QuanLySanPham.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard Quản trị")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Tổng quan",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  _DashboardCard(
                    title: "Đơn hôm nay",
                    value: "12",
                    icon: Icons.shopping_cart,
                    color: Colors.orange,
                  ),
                  _DashboardCard(
                    title: "Doanh thu hôm nay",
                    value: "3.200.000đ",
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                  _DashboardCard(
                    title: "Sản phẩm bán chạy",
                    value: "Tã Pampers NB90",
                    icon: Icons.trending_up,
                    color: Colors.blue,
                  ),
                  _DashboardCard(
                    title: "Đơn chờ duyệt",
                    value: "5",
                    icon: Icons.access_time,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                "Chức năng quản trị",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.inventory),
                title: const Text("Quản lý sản phẩm"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Điều hướng đến màn hình quản lý sản phẩm
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Admin_QuanLySanPhamScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text("Quản lý đơn hàng"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Điều hướng đến màn hình quản lý đơn hàng
                },
              ),
              ListTile(
                leading: const Icon(Icons.people),
                title: const Text("Quản lý người dùng"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Điều hướng đến màn hình quản lý người dùng
                },
              ),
            ],
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
