import 'package:flutter/material.dart';
import '../../model/SanPhamModel.dart';
import '../../services/SanPhamServices.dart';
import '../screen/ChiTietSanPham/ChiTietSanPham.dart';

class DanhSachSanPham extends StatefulWidget {
  const DanhSachSanPham({super.key});

  @override
  State<DanhSachSanPham> createState() => _DanhSachSanPhamState();
}

class _DanhSachSanPhamState extends State<DanhSachSanPham> {
  late Future<List<SanPham>> _futureSanPham;

  @override
  void initState() {
    super.initState();
    _futureSanPham = SanPhamService.fetchSanPham();
  }

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
        FutureBuilder<List<SanPham>>(
          future: _futureSanPham,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Không có sản phẩm nào'));
            }

            final sanPham = snapshot.data!;

            return ListView.separated(
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
                        builder: (_) => ChiTietSanPham(sanPham: sp),
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
                            'assets/images/${sp.hinhAnh}',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                const Icon(Icons.broken_image),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sp.ten,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Danh mục: ${sp.danhMuc} - Loại: ${sp.loai}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${sp.gia.toStringAsFixed(0)}đ',
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
            );
          },
        ),
      ],
    );
  }
}
