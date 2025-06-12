import 'package:flutter/material.dart';

class HorizontalFeatureMenu extends StatelessWidget {
  const HorizontalFeatureMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {'icon': Icons.card_giftcard, 'label': 'Ưu đãi'},
      {'icon': Icons.receipt, 'label': 'Hóa đơn'},
      {'icon': Icons.discount, 'label': 'Voucher'},
      {'icon': Icons.star_border, 'label': 'Thẻ'},
      {'icon': Icons.support_agent, 'label': 'CSKH'},
      {'icon': Icons.store, 'label': 'Cửa hàng'},
    ];

    return SizedBox(
      height: 72, // ✅ giảm nhẹ chiều cao tổng
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: features.map((feature) {
            return Container(
              margin: const EdgeInsets.only(left: 12, right: 16),
              width: 80, // ✅ tăng chiều ngang mỗi ô
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10), // padding gọn lại dọc, rộng ngang
              decoration: BoxDecoration(
                border: Border.all(color: Colors.pink),
                borderRadius: BorderRadius.circular(10),
              ),
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Chọn: ${feature['label']}")),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(feature['icon'], size: 20, color: Colors.pink),
                    const SizedBox(height: 4),
                    Text(
                      feature['label'],
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
