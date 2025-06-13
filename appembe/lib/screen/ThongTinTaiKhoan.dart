import 'package:flutter/material.dart';

class MH_ThongTinTaiKhoan extends StatelessWidget {
  const MH_ThongTinTaiKhoan({super.key});

  final List<Map<String, dynamic>> accountOptions = const [
    {'icon': Icons.person, 'label': 'Thông tin tài khoản'},
    {'icon': Icons.list_alt, 'label': 'Quản lý đơn hàng'},
    {'icon': Icons.location_on, 'label': 'Sổ địa chỉ'},
    {'icon': Icons.notifications, 'label': 'Thông báo của tôi'},
    {'icon': Icons.rate_review, 'label': 'Nhận xét sản phẩm đã mua'},
    {'icon': Icons.visibility, 'label': 'Sản phẩm đã xem'},
    {'icon': Icons.favorite_border, 'label': 'Sản phẩm yêu thích'},
    {'icon': Icons.access_time, 'label': 'Sản phẩm mua sau'},
    {'icon': Icons.edit, 'label': 'Nhận xét của tôi'},
    {'icon': Icons.help_outline, 'label': 'Hỏi đáp'},
    {'icon': Icons.monetization_on, 'label': 'Kicoin'},
    {'icon': Icons.card_giftcard, 'label': 'Ví ưu đãi'},
    {'icon': Icons.delete_forever, 'label': 'Xóa tài khoản'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // 🔷 Header thông tin người dùng
          Container(
            color: Colors.lightBlue,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Text('n', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Xin chào', style: TextStyle(color: Colors.white70)),
                    Text(
                      'nhan nhan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),

          // 📝 Danh sách chức năng tài khoản
          Expanded(
            child: ListView.separated(
              itemCount: accountOptions.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = accountOptions[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.lightBlueAccent,
                    child: Icon(item['icon'], color: Colors.white, size: 20),
                  ),
                  title: Text(item['label']),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Chọn: ${item['label']}')),
                    );
                  },
                );
              },
            ),
          ),

          // 📞 Tư vấn bán hàng
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.phone, color: Colors.lightBlue),
                SizedBox(width: 8),
                Text(
                  'Tư vấn bán hàng  ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('1800.6608', style: TextStyle(color: Colors.lightBlue)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
