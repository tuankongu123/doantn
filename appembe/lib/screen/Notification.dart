import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tiêu đề và TabBar
        Container(
          color: const Color(0xFF27C2DB),
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          height: 50,
          alignment: Alignment.centerLeft,
          child: const Text(
            'Thông báo của tôi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),

        const Material(
          color: Color(0xFF27C2DB),
          child: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            indicatorColor: Colors.black,
            tabs: [
              Tab(text: 'Đơn hàng'),
              Tab(text: 'Ưu đãi'),
              Tab(text: 'Hệ thống'),
            ],
          ),
        ),

        // Nội dung các tab
        const Expanded(
          child: TabBarView(
            children: [
              Center(child: Text('Thông báo đơn hàng ...')),
              Center(child: Text('Thông báo ưu đãi ...')),
              Center(child: Text('Thông báo hệ thống ...')),
            ],
          ),
        ),
      ],
    );
  }
}
