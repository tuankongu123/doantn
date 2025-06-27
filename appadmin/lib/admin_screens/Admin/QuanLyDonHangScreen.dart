import 'package:appadmin/models/donhang_model.dart' show DonHang;
import 'package:appadmin/admin_services/DonHangServices.dart';
import 'package:flutter/material.dart';

class QuanLyDonHangScreen extends StatefulWidget {
  const QuanLyDonHangScreen({super.key});

  @override
  State<QuanLyDonHangScreen> createState() => _QuanLyDonHangScreenState();
}

class _QuanLyDonHangScreenState extends State<QuanLyDonHangScreen> {
  late Future<List<DonHang>> _donHangFuture;
  String? _trangThai;

  @override
  void initState() {
    super.initState();
    _loadDonHang();
  }

  void _loadDonHang() {
    setState(() {
      _donHangFuture = DonHangService.fetchDonHang(trangThai: _trangThai);
    });
  }

  void _duyetDon(int id) async {
    bool ok = await DonHangService.duyetDon(id);
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đã duyệt đơn")));
      _loadDonHang();
    }
  }

  void _showChiTiet(int donHangId) async {
    final chitiets = await DonHangService.fetchChiTiet(donHangId);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Chi tiết đơn hàng"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: chitiets
                .map(
                  (e) => ListTile(
                    title: Text(e.tenSanPham),
                    subtitle: Text("SL: ${e.soLuong} - Giá: ${e.gia}"),
                  ),
                )
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý đơn hàng")),
      body: Column(
        children: [
          DropdownButton<String>(
            hint: const Text("Lọc trạng thái"),
            value: _trangThai,
            onChanged: (value) {
              setState(() {
                _trangThai = value;
                _loadDonHang();
              });
            },
            items: const [
              DropdownMenuItem(value: null, child: Text("Tất cả")),
              DropdownMenuItem(value: "cho_duyet", child: Text("Chờ duyệt")),
              DropdownMenuItem(value: "da_duyet", child: Text("Đã duyệt")),
            ],
          ),
          Expanded(
            child: FutureBuilder<List<DonHang>>(
              future: _donHangFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Lỗi: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Không có đơn hàng"));
                }

                return ListView(
                  children: snapshot.data!.map((don) {
                    return Card(
                      child: ListTile(
                        title: Text("Khách: ${don.tenNguoiDung}"),
                        subtitle: Text(
                          "Ngày: ${don.ngayTao} | Trạng thái: ${don.trangThai}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.info),
                              onPressed: () => _showChiTiet(don.id),
                            ),
                            if (don.trangThai == 'cho_duyet')
                              IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () => _duyetDon(don.id),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
