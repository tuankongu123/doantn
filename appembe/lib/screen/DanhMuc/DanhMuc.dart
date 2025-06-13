import 'package:flutter/material.dart';

class MH_DanhMuc extends StatelessWidget {
  const MH_DanhMuc({super.key});

  final List<Map<String, dynamic>> categories = const [
    {'title': 'Mẹ bầu và sau sinh', 'color': Color(0xFFFFEB3B), 'icon': Icons.favorite},
    {'title': 'Sữa cho bé', 'color': Color(0xFFFFCDD2), 'icon': Icons.local_drink},
    {'title': 'Bé ăn dặm', 'color': Color(0xFFB2EBF2), 'icon': Icons.restaurant},
    {'title': 'Bỉm tã và vệ sinh', 'color': Color(0xFF81D4FA), 'icon': Icons.clean_hands},
    {'title': 'Bình sữa và phụ kiện', 'color': Color(0xFFFFF176), 'icon': Icons.baby_changing_station},
    {'title': 'Đồ sơ sinh', 'color': Color(0xFFB2EBF2), 'icon': Icons.child_care},
    {'title': 'Thời trang và phụ kiện', 'color': Color(0xFFFFCDD2), 'icon': Icons.shopping_bag},
    {'title': 'Vitamin và sức khoẻ', 'color': Color(0xFFC8E6C9), 'icon': Icons.apple},
    {'title': 'Đồ dùng mẹ và bé', 'color': Color(0xFFFFF176), 'icon': Icons.kitchen},
    {'title': 'Giặt xả và Tắm gội', 'color': Color(0xFFFF8A80), 'icon': Icons.soap},
    {'title': 'Đồ chơi và Học tập', 'color': Color(0xFF81D4FA), 'icon': Icons.lightbulb},
    {'title': 'Hàng mới về', 'color': Color(0xFF80DEEA), 'icon': Icons.new_releases},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 90,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final item = categories[index];
            return GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Chọn danh mục: ${item['title']}")),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: item['color'],
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(item['icon'], size: 32, color: Colors.blue.shade900),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        item['title'],
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
