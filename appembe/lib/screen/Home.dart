import 'package:appembe/screen/AccountInfoScreen.dart';
import 'package:appembe/screen/Banner.dart';
import 'package:appembe/screen/CustomBottomNavBar.dart';
import 'package:appembe/screen/FeatureMenu.dart';
import 'package:appembe/screen/FlashSaleSection.dart';
import 'package:appembe/screen/SearchBar.dart';
import 'package:flutter/material.dart';
import 'package:appembe/screen/Menu.dart';
import 'package:appembe/screen/Notification.dart';

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
            : const CustomSearchAppBar(), // 🔍 Chỉ hiện với các tab khác
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
                  HorizontalFeatureMenu(),
                  SizedBox(height: 20),
                  FlashSaleSection(),
                  SizedBox(height: 150),
                  SizedBox(height: 10),
                  SizedBox(height: 120),
                ],
              ),
            ),

            // Trang 1: Danh mục
            const ProductMenuScreen(),

            // Trang 2: Ưu đãi
            const Center(child: Text('Ưu đãi đặc biệt')),

            // Trang 3: Thông báo
            const NotificationScreen(),

            // Trang 4: Cá nhân
            const AccountInfoScreen(),
          ],
        ),

        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),

        backgroundColor: Colors.white,
      ),
    );
  }
}