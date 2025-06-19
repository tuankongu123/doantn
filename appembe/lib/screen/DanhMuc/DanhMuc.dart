import 'package:flutter/material.dart';
import '../../model/DanhMucModel.dart';
import '../../model/SanPhamModel.dart';
import '../../services/DanhMucServices.dart';
import '../../services/SanPhamServices.dart';

class MH_DanhMuc extends StatefulWidget {
  const MH_DanhMuc({super.key});

  @override
  State<MH_DanhMuc> createState() => _MH_DanhMucState();
}

class _MH_DanhMucState extends State<MH_DanhMuc> {
  late Future<List<DanhMuc>> _futureDanhMuc;
  List<SanPham> _sanPhamTheoDanhMuc = [];
  int? _selectedDanhMucId;
  String? _selectedDanhMucTen;

  @override
  void initState() {
    super.initState();
    _futureDanhMuc = DanhMucService.fetchDanhMuc();
  }

  Future<void> _loadSanPhamByDanhMuc(int danhMucId, String tenDanhMuc) async {
    final sanPhamList = await SanPhamService.fetchByDanhMucId(
      danhMucId,
    ); // Viết API này
    setState(() {
      _selectedDanhMucId = danhMucId;
      _selectedDanhMucTen = tenDanhMuc;
      _sanPhamTheoDanhMuc = sanPhamList;
    });
  }

  Color getRandomColor(int index) {
    final colors = [
      Colors.amber.shade100,
      Colors.pink.shade100,
      Colors.cyan.shade100,
      Colors.blue.shade100,
      Colors.lime.shade100,
      Colors.green.shade100,
    ];
    return colors[index % colors.length];
  }

  final List<IconData> icons = [
    Icons.category,
    Icons.shopping_cart,
    Icons.baby_changing_station,
    Icons.favorite,
    Icons.clean_hands,
    Icons.toys,
    Icons.child_care,
    Icons.shopping_bag,
    Icons.apple,
    Icons.soap,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh mục")),
      body: FutureBuilder<List<DanhMuc>>(
        future: _futureDanhMuc,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có danh mục nào"));
          }

          final danhMucs = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Danh sách danh mục
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: danhMucs.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 90,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemBuilder: (context, index) {
                      final item = danhMucs[index];
                      return GestureDetector(
                        onTap: () => _loadSanPhamByDanhMuc(item.id, item.ten),
                        child: Container(
                          decoration: BoxDecoration(
                            color: getRandomColor(index),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                icons[index % icons.length],
                                size: 32,
                                color: Colors.blue.shade900,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.ten,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const Divider(),

                // Danh sách sản phẩm thuộc danh mục
                if (_selectedDanhMucId != null) ...[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sản phẩm thuộc danh mục: $_selectedDanhMucTen',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  ListView.builder(
                    itemCount: _sanPhamTheoDanhMuc.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final sp = _sanPhamTheoDanhMuc[index];
                      return ListTile(
                        leading: Image.asset(
                          'assets/images/${sp.hinhAnh}',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(sp.ten),
                        subtitle: Text('${sp.gia.toStringAsFixed(0)}đ'),
                        trailing: const Icon(Icons.chevron_right),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
