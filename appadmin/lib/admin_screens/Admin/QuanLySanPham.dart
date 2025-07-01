import 'package:appadmin/admin_screens/Admin/QuanLySanPham/UpFile.dart';
import 'package:appadmin/admin_screens/ChiTietSanPham/ChiTietSanPham.dart';
import 'package:flutter/material.dart';
import 'package:appadmin/models/SanPhamModel.dart';
import 'package:appadmin/models/DanhMucModel.dart';
import 'package:appadmin/models/ThuongHieuModel.dart';
import 'package:appadmin/admin_services/SanPhamServices.dart';
import 'package:appadmin/admin_services/DanhMucServices.dart';
import 'package:appadmin/admin_services/ThuongHieuServices.dart';
import 'package:appadmin/widget/ThanhTimKiem.dart';

class Admin_QuanLySanPhamScreen extends StatefulWidget {
  const Admin_QuanLySanPhamScreen({super.key});

  @override
  State<Admin_QuanLySanPhamScreen> createState() =>
      _Admin_QuanLySanPhamScreenState();
}

class _Admin_QuanLySanPhamScreenState extends State<Admin_QuanLySanPhamScreen> {
  late Future<List<DanhMuc>> _futureDanhMuc;
  int? _selectedDanhMucId;
  int? _selectedThuongHieuId;
  Future<List<SanPham>>? _futureSanPham;
  Future<List<ThuongHieu>>? _futureThuongHieu;

  final TextEditingController _searchController = TextEditingController();
  bool _dangTimKiem = false;
  String? _tuKhoaTimKiem;

  @override
  void initState() {
    super.initState();
    _futureDanhMuc = DanhMucService.fetchDanhMuc();
    _futureDanhMuc.then((ds) {
      if (ds.isNotEmpty) {
        _chonDanhMuc(ds.first.id);
      }
    });
  }

  void _chonDanhMuc(int id) {
    setState(() {
      _selectedDanhMucId = id;
      _selectedThuongHieuId = null;
      _dangTimKiem = false;
      _tuKhoaTimKiem = null;
      _searchController.clear();
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
    keyword = keyword.trim();
    if (keyword.isEmpty) return;
    setState(() {
      _dangTimKiem = true;
      _tuKhoaTimKiem = keyword;
      _futureSanPham = SanPhamService.fetchByKeyword(keyword);
    });
  }

  void _xoaTimKiem() {
    setState(() {
      _dangTimKiem = false;
      _tuKhoaTimKiem = null;
      _searchController.clear();
      if (_selectedDanhMucId != null) {
        _futureSanPham = SanPhamService.fetchByDanhMucId(_selectedDanhMucId!);
      }
    });
  }

  void _moManHinhThemExcel() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const UploadExcelScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TP_ThanhTimKiem(
        controller: _searchController,
        onSubmitted: _timKiemSanPham,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_dangTimKiem)
              Row(
                children: [
                  Text("🔍 Đang tìm: '$_tuKhoaTimKiem'"),
                  const SizedBox(width: 10),
                  TextButton.icon(
                    onPressed: _xoaTimKiem,
                    icon: const Icon(Icons.clear),
                    label: const Text("Xoá tìm kiếm"),
                  ),
                ],
              ),
            FutureBuilder<List<DanhMuc>>(
              future: _futureDanhMuc,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final danhMucs = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Danh mục",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 8,
                      children: danhMucs.map((dm) {
                        return ChoiceChip(
                          label: Text(dm.ten),
                          selected: dm.id == _selectedDanhMucId,
                          onSelected: (_) => _chonDanhMuc(dm.id),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            if (!_dangTimKiem && _futureThuongHieu != null)
              FutureBuilder<List<ThuongHieu>>(
                future: _futureThuongHieu,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox();
                  final ths = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Thương hiệu",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Wrap(
                        spacing: 8,
                        children: ths.map((th) {
                          return ChoiceChip(
                            label: Text(th.ten),
                            selected: th.id == _selectedThuongHieuId,
                            onSelected: (_) => _chonThuongHieu(th.id),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
            const Divider(),
            Expanded(
              child: FutureBuilder<List<SanPham>>(
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
                    itemBuilder: (ctx, i) {
                      final sp = sps[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 3,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChiTietSanPham(sanPham: sp),
                              ),
                            );
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/${sp.hinhAnh}',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            sp.ten,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "${sp.gia.toStringAsFixed(0)}đ - SL: ${sp.soLuong}",
                          ),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _moManHinhThemExcel,
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
        tooltip: 'Thêm từ Excel',
      ),
    );
  }
}
