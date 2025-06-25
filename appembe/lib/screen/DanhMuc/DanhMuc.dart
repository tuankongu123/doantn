import 'package:appembe/model/ThuongHieuModel.dart';
import 'package:appembe/services/ThuongHieuServices.dart';
import 'package:appembe/widget/DanhMucWidget.dart';
import 'package:flutter/material.dart';
import '../../model/DanhMucModel.dart';
import '../../model/SanPhamModel.dart';
import '../../services/DanhMucServices.dart';
import '../../services/SanPhamServices.dart';
import '../../widget/SanPham.dart';

class MH_DanhMuc extends StatefulWidget {
  const MH_DanhMuc({super.key});

  @override
  State<MH_DanhMuc> createState() => _MH_DanhMucState();
}

class _MH_DanhMucState extends State<MH_DanhMuc> {
  late Future<List<DanhMuc>> _futureDanhMuc;
  int? _selectedDanhMucId;
  String? _selectedDanhMucTen;
  Future<List<SanPham>>? _futureSanPhamTheoDanhMuc;
  Future<List<ThuongHieu>>? _futureThuongHieu;
  int? _selectedThuongHieuId;

  @override
  void initState() {
    super.initState();

    _futureDanhMuc = DanhMucService.fetchDanhMuc();

    // Sau khi fetch xong danh mục, tự động chọn danh mục có ID = 1
    _futureDanhMuc.then((danhMucs) {
      final danhMuc1 = danhMucs.firstWhere(
        (dm) => dm.id == 1,
        orElse: () => DanhMuc(
          id: 1,
          ten: 'Danh mục 1',
          moTa: '',
        ), // fallback nếu không tìm thấy
      );

      _loadSanPhamByDanhMuc(danhMuc1.id, danhMuc1.ten);
    });
  }

  void _loadSanPhamByDanhMuc(int danhMucId, String tenDanhMuc) {
    setState(() {
      _selectedDanhMucId = danhMucId;
      _selectedDanhMucTen = tenDanhMuc;
      _selectedThuongHieuId = null;
      _futureSanPhamTheoDanhMuc = SanPhamService.fetchByDanhMucId(danhMucId);
      _futureThuongHieu = ThuongHieuService.fetchThuongHieuTheoDanhMuc(
        danhMucId,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Danh mục")),
      body: Column(
        children: [
          // --- PHẦN DANH MỤC: Cuộn ngang ---
          FutureBuilder<List<DanhMuc>>(
            future: _futureDanhMuc,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(child: Text("Không có danh mục nào")),
                );
              }

              final danhMucs = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DanhMucWidget(
                    danhMucs: danhMucs,
                    selectedId: _selectedDanhMucId,
                    onSelect: (danhMuc) {
                      _loadSanPhamByDanhMuc(danhMuc.id, danhMuc.ten);
                    },
                  ),

                  const SizedBox(height: 8),
                  Text("Thương hiệu"),

                  // GỌI THƯƠNG HIỆU Ở ĐÂY
                  if (_futureThuongHieu != null)
                    FutureBuilder<List<ThuongHieu>>(
                      future: _futureThuongHieu,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const SizedBox(); // Không có thương hiệu
                        }

                        final thuongHieus = snapshot.data!;
                        return SizedBox(
                          height: 48,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: thuongHieus.length,
                            itemBuilder: (context, index) {
                              final th = thuongHieus[index];
                              final isSelected = th.id == _selectedThuongHieuId;

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: ChoiceChip(
                                  label: Text(th.ten),
                                  selected: isSelected,
                                  onSelected: (_) {
                                    setState(() {
                                      _selectedThuongHieuId = th.id;
                                      _futureSanPhamTheoDanhMuc =
                                          SanPhamService.fetchByDanhMucAndThuongHieu(
                                            _selectedDanhMucId!,
                                            _selectedThuongHieuId!,
                                          );
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                ],
              );
            },
          ),

          const Divider(),

          // --- PHẦN SẢN PHẨM ---
          Expanded(
            child:
                (_selectedDanhMucId != null &&
                    _futureSanPhamTheoDanhMuc != null)
                ? DanhSachSanPham(
                    futureSanPham: _futureSanPhamTheoDanhMuc!,
                    tieuDe: 'Sản phẩm: $_selectedDanhMucTen',
                  )
                : const Center(
                    child: Text("Vui lòng chọn danh mục để xem sản phẩm"),
                  ),
          ),
        ],
      ),
    );
  }
}
