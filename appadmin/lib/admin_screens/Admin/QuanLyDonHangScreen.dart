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

  Future<void> _duyetDon(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Bạn có chắc chắn muốn duyệt đơn này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Duyệt"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final ok = await DonHangService.duyetDon(id);
      if (ok) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("✅ Đã duyệt đơn")));
        _loadDonHang();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Không đủ tồn kho để duyệt đơn")),
        );
      }
    }
  }

  Future<void> _huyDon(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận hủy"),
        content: const Text("Bạn có chắc chắn muốn hủy đơn này không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Đóng"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hủy đơn"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final ok = await DonHangService.huyDon(id);
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🗑️ Đã hủy đơn và hoàn kho")),
        );
        _loadDonHang();
      }
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

  String hienThiTrangThai(String? trangThai) {
    switch (trangThai) {
      case 'cho_duyet':
        return '🕒 Chờ duyệt';
      case 'da_duyet':
        return '✅ Đã duyệt';
      case 'dang_giao':
        return '🚚 Đang giao';
      case 'da_xong':
        return '✔️ Hoàn thành';
      case 'huy':
        return '❌ Đã hủy';
      default:
        return 'Không rõ';
    }
  }

  Color mauTrangThai(String? trangThai) {
    switch (trangThai) {
      case 'cho_duyet':
        return Colors.orange;
      case 'da_duyet':
        return Colors.green;
      case 'dang_giao':
        return Colors.blueAccent;
      case 'da_xong':
        return Colors.grey;
      case 'huy':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý đơn hàng")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _trangThai,
              hint: const Text("Lọc trạng thái"),
              isExpanded: true,
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
                DropdownMenuItem(value: "dang_giao", child: Text("Đang giao")),
                DropdownMenuItem(value: "da_xong", child: Text("Hoàn thành")),
                DropdownMenuItem(value: "huy", child: Text("Đã hủy")),
              ],
            ),
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
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Ngày: ${don.ngayTao}"),
                            Text(
                              "Trạng thái: ${hienThiTrangThai(don.trangThai)}",
                              style: TextStyle(
                                color: mauTrangThai(don.trangThai),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.blue,
                              ),
                              tooltip: "Xem chi tiết",
                              onPressed: () => _showChiTiet(don.id),
                            ),
                            if (don.trangThai == 'cho_duyet')
                              IconButton(
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                tooltip: "Duyệt đơn",
                                onPressed: () => _duyetDon(don.id),
                              ),
                            if (don.trangThai != 'da_xong' &&
                                don.trangThai != 'huy')
                              IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                tooltip: "Hủy đơn",
                                onPressed: () => _huyDon(don.id),
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
