import 'package:appadmin/admin_screens/ChiTietSanPham/ChiTietSanPham.dart';
import 'package:appadmin/models/ThuongHieuModel.dart';
import 'package:appadmin/admin_screens/Admin/QuanLySanPham/NhapKho.dart';
import 'package:appadmin/admin_screens/Admin/QuanLySanPham/SuaSanPham.dart';
import 'package:appadmin/admin_screens/Admin/QuanLySanPham/ThemSanPham.dart';
import 'package:appadmin/admin_screens/Admin/QuanLySanPham/TonKho.dart';
import 'package:appadmin/admin_screens/Admin/QuanLySanPham/UpFile.dart';
import 'package:appadmin/admin_services/ThuongHieuServices.dart';
import 'package:appadmin/widget/DanhMucWidget.dart';
import 'package:appadmin/widget/ThanhTimKiem.dart';
import 'package:flutter/material.dart';
import '../../../models/DanhMucModel.dart';
import '../../../models/SanPhamModel.dart';
import '../../../admin_services/DanhMucServices.dart';
import '../../../admin_services/SanPhamServices.dart';

class Admin_QuanLySanPhamScreen extends StatefulWidget {
  const Admin_QuanLySanPhamScreen({super.key});

  @override
  State<Admin_QuanLySanPhamScreen> createState() =>
      _Admin_QuanLySanPhamScreenState();
}

class _Admin_QuanLySanPhamScreenState extends State<Admin_QuanLySanPhamScreen> {
  late Future<List<DanhMuc>> _futureDanhMuc;
  int? _selectedDanhMucId;
  String? _selectedDanhMucTen;
  Future<List<SanPham>>? _futureSanPham;
  Future<List<ThuongHieu>>? _futureThuongHieu;
  int? _selectedThuongHieuId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureDanhMuc = DanhMucService.fetchDanhMuc();
    _futureDanhMuc.then((ds) {
      if (ds.isNotEmpty) {
        _chonDanhMuc(ds.first.id, ds.first.ten);
      }
    });
  }

  void _chonDanhMuc(int id, String ten) {
    setState(() {
      _selectedDanhMucId = id;
      _selectedDanhMucTen = ten;
      _selectedThuongHieuId = null;
      _futureSanPham = SanPhamService.fetchByDanhMucId(id);
      _futureThuongHieu = ThuongHieuService.fetchThuongHieuTheoDanhMuc(id);
    });
  }

  void _chonThuongHieu(int id) {
    setState(() {
      _selectedThuongHieuId = id;
      _futureSanPham = SanPhamService.fetchByDanhMucAndThuongHieu(
        _selectedDanhMucId!,
        id,
      );
    });
  }

  void _timKiemSanPham(String keyword) {
    if (keyword.trim().isEmpty) return;
    setState(() {
      _futureSanPham = SanPhamService.fetchByKeyword(keyword.trim());
    });
  }

  void _taiLaiSanPham() {
    if (_selectedDanhMucId != null) {
      if (_selectedThuongHieuId != null) {
        _futureSanPham = SanPhamService.fetchByDanhMucAndThuongHieu(
          _selectedDanhMucId!,
          _selectedThuongHieuId!,
        );
      } else {
        _futureSanPham = SanPhamService.fetchByDanhMucId(_selectedDanhMucId!);
      }
      setState(() {});
    }
  }

  void _xoaSanPham(int id) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xoá sản phẩm"),
        content: const Text("Bạn có chắc muốn xoá sản phẩm này?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Không"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Xoá"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await SanPhamService.xoa(id);
      _taiLaiSanPham();
    }
  }

  void _xemChiTiet(SanPham sp) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChiTietSanPham(sanPham: sp)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TP_ThanhTimKiem(
        controller: _searchController,
        onSubmitted: _timKiemSanPham,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UploadExcelScreen(onThemXong: _taiLaiSanPham),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<List<DanhMuc>>(
                future: _futureDanhMuc,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    );
                  }
                  final danhMucs = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DanhMucWidget(
                        danhMucs: danhMucs,
                        selectedId: _selectedDanhMucId,
                        onSelect: (dm) => _chonDanhMuc(dm.id, dm.ten),
                      ),
                      const SizedBox(height: 8),
                      const Text("Thương hiệu"),
                      if (_futureThuongHieu != null)
                        FutureBuilder<List<ThuongHieu>>(
                          future: _futureThuongHieu,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const SizedBox();
                            final ths = snapshot.data!;
                            return Wrap(
                              spacing: 8,
                              children: ths.map((th) {
                                return ChoiceChip(
                                  label: Text(th.ten),
                                  selected: th.id == _selectedThuongHieuId,
                                  onSelected: (_) => _chonThuongHieu(th.id),
                                );
                              }).toList(),
                            );
                          },
                        ),
                    ],
                  );
                },
              ),
              const Divider(),
              Expanded(
                child: (_futureSanPham != null)
                    ? FutureBuilder<List<SanPham>>(
                        future: _futureSanPham,
                        builder: (ctx, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final sps = snapshot.data!;
                          if (sps.isEmpty) {
                            return const Center(
                              child: Text("Không có sản phẩm"),
                            );
                          }
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 3.5,
                                ),
                            itemCount: sps.length,
                            itemBuilder: (ctx, index) {
                              final sp = sps[index];
                              return Card(
                                child: ListTile(
                                  onTap: () => _xemChiTiet(sp),
                                  leading: Image.asset(
                                    'assets/images/${sp.hinhAnh}',
                                    width: 48,
                                  ),
                                  title: Text(sp.ten),
                                  subtitle: Text(
                                    "${sp.gia.toStringAsFixed(0)}đ • SL: ${sp.soLuong}",
                                  ),
                                  trailing: PopupMenuButton(
                                    onSelected: (value) async {
                                      if (value == 'sua') {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => SuaSanPhamScreen(
                                              sp.id,
                                              onCapNhatXong: _taiLaiSanPham,
                                            ),
                                          ),
                                        );
                                      } else if (value == 'xoa') {
                                        _xoaSanPham(sp.id);
                                      } else if (value == 'tonkho') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => TonKhoScreen(sp.id),
                                          ),
                                        );
                                      } else if (value == 'nhapkho') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => NhapKhoScreen(
                                              sp.id,
                                              onNhapXong: _taiLaiSanPham,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    itemBuilder: (_) => const [
                                      PopupMenuItem(
                                        value: 'sua',
                                        child: Text("Sửa"),
                                      ),
                                      PopupMenuItem(
                                        value: 'nhapkho',
                                        child: Text("Nhập kho"),
                                      ),
                                      PopupMenuItem(
                                        value: 'tonkho',
                                        child: Text("Tồn kho"),
                                      ),
                                      PopupMenuItem(
                                        value: 'xoa',
                                        child: Text("Xoá"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      )
                    : const Center(child: Text("Vui lòng chọn danh mục")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
