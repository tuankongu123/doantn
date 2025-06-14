import 'package:appembe/widget/CountdownTimer.dart';
import 'package:flutter/material.dart';

class FlashSaleSection extends StatelessWidget {
  const FlashSaleSection({super.key});

  // Dữ liệu mẫu
  final List<Map<String, dynamic>> products = const [
    {
      'image': 'assets/images/lan_chong_muoi.jfif',
      'name': 'Lăn chống muỗi Chicco 60ml',
      'discount': 15,
      'originalPrice': 265000,
      'salePrice': 229000,
    },
    {
      'image': 'assets/images/sua_nan.jfif',
      'name': 'Sữa nan Morinaga vị Cafe Nhật (216g)',
      'discount': 16,
      'originalPrice': 230000,
      'salePrice': 190000,
    },
    {
      'image': 'assets/images/kem_duong_am.jfif',
      'name': 'Kem dưỡng ẩm Chicco 100ml',
      'discount': 12,
      'originalPrice': 210000,
      'salePrice': 185000,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🔵 Header flash sale
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.blue.shade800,
          child: Row(
            children: [
              const Text(
                'FLASH SALE 🔥',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              CountdownTimerWidget(duration: const Duration(hours: 3)),
              const Spacer(),
            ],
          ),
        ),

        // 🛒 Danh sách sản phẩm vuốt ngang
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 16, top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ảnh và nhãn giảm giá
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            product['image'],
                            width: 150,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '-${product['discount']}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    Text(
                      product['name'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),

                    const SizedBox(height: 4),
                    Text(
                      '${product['originalPrice']}đ',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),

                    Text(
                      '${product['salePrice']}đ',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),
                    const Text(
                      'Thanh toán với Kredivo',
                      style: TextStyle(fontSize: 10, color: Colors.blue),
                    ),
                    const Text(
                      'Chỉ từ 6.234đ/tháng',
                      style: TextStyle(fontSize: 10, color: Colors.black87),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
