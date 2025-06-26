import 'package:appembe/model/ThuongHieuModel.dart';
import 'package:appembe/screen/Admin/QuanLySanPham/NhapKho.dart';
import 'package:appembe/screen/Admin/QuanLySanPham/SuaSanPham.dart';
import 'package:appembe/screen/Admin/QuanLySanPham/ThemSanPham.dart';
import 'package:appembe/screen/Admin/QuanLySanPham/TonKho.dart';
import 'package:appembe/screen/Admin/QuanLySanPham/UpFile.dart';
import 'package:appembe/services/ThuongHieuServices.dart';
import 'package:appembe/widget/DanhMucWidget.dart';
import 'package:flutter/material.dart';
import '../../../model/DanhMucModel.dart';
import '../../../model/SanPhamModel.dart';
import '../../../services/DanhMucServices.dart';
import '../../../services/SanPhamServices.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý sản phẩm")),
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
      body: Column(
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
                        return SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: ths.length,
                            itemBuilder: (ctx, i) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: ChoiceChip(
                                label: Text(ths[i].ten),
                                selected: ths[i].id == _selectedThuongHieuId,
                                onSelected: (_) => _chonThuongHieu(ths[i].id),
                              ),
                            ),
                          ),
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
                        return const Center(child: CircularProgressIndicator());
                      }
                      final sps = snapshot.data!;
                      if (sps.isEmpty) {
                        return const Center(child: Text("Không có sản phẩm"));
                      }
                      return ListView.builder(
                        itemCount: sps.length,
                        itemBuilder: (ctx, index) {
                          final sp = sps[index];
                          return Card(
                            child: ListTile(
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
    );
  }
}
