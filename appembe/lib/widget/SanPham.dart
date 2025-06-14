import 'package:flutter/material.dart';
import '../screen/ChiTietSanPham/ChiTietSanPham.dart';

class DanhSachSanPham extends StatelessWidget {
  const DanhSachSanPham({super.key});

  final List<Map<String, dynamic>> sanPham = const [
    {
      'image': 'assets/images/sua_tuoi_tiet_trung.jfif',
      'ten': 'Sữa GrowPlus+ Nutifood (110ml x4)',
      'gia': 38000,
      'thuongHieu': 'Nutifood',
      'moTa': 'Sữa uống dinh dưỡng dành cho trẻ biếng ăn.',
    },
    {
      'image': 'assets/images/ta_bobby.jfif',
      'ten': 'Sữa Friso Gold 4 (900g)',
      'gia': 485000,
      'thuongHieu': 'Friso',
      'moTa': 'Sữa bột cho trẻ từ 3-6 tuổi, hỗ trợ tiêu hóa.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Sản phẩm',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: sanPham.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final sp = sanPham[index];
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChiTietSanPhamScreen(sanPham: sp),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        sp['image'],
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            sp['ten'],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'by ${sp['thuongHieu']}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: Colors.blueAccent,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${sp['gia']}đ',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
