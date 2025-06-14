import 'package:appembe/screen/ThongTinTaiKhoan/MH_ThongTinTaiKhoan.dart';
import 'package:appembe/widget/Banner.dart';
import 'package:appembe/widget/ThanhDieuHuong.dart';
import 'package:appembe/widget/ThanhChucNang.dart';
import 'package:appembe/widget/FlashSaleSection.dart';
import 'package:appembe/widget/ThanhTimKiem.dart';
import 'package:appembe/widget/SanPham.dart';
import 'package:flutter/material.dart';
import 'package:appembe/screen/DanhMuc/DanhMuc.dart';
import 'package:appembe/screen/ThongBao/ThongBao.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Tab cho NotificationScreen
      child: Scaffold(
        appBar: _selectedIndex == 3 || _selectedIndex == 4
            ? null // 👉 Ẩn AppBar nếu là tab Notification
            : const TP_ThanhTimKiem(), // 🔍 Chỉ hiện với các tab khác
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Trang 0: Trang chủ
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: const [
                  Baner(),
                  SizedBox(height: 12),
                  TP_ThanhChucNang(),
                  SizedBox(height: 20),
                  FlashSaleSection(),
                  SizedBox(height: 20),
                  DanhSachSanPham(),
                  SizedBox(height: 150),
                  SizedBox(height: 10),
                  SizedBox(height: 120),
                ],
              ),
            ),

            // Trang 1: Danh mục
            const MH_DanhMuc(),

            // Trang 2: Ưu đãi
            const Center(child: Text('Ưu đãi đặc biệt')),

            // Trang 3: Thông báo
            const MH_ThongBao(),

            // Trang 4: Cá nhân
            const MH_ThongTinTaiKhoan(),
          ],
        ),

        bottomNavigationBar: TP_ThanhDieuHuong(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),

        backgroundColor: Colors.white,
      ),
    );
  }
}
