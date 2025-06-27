import 'package:flutter/material.dart';
import 'package:appembe/model/GioHangModel.dart';
import 'package:appembe/screen/DonHang/DatHangScreen.dart';
import 'package:appembe/services/GioHangServices.dart';

class GioHangScreen extends StatefulWidget {
  final int nguoiDungId;
  const GioHangScreen({super.key, required this.nguoiDungId});

  @override
  State<GioHangScreen> createState() => _GioHangScreenState();
}

class _GioHangScreenState extends State<GioHangScreen> {
  List<GioHangItem> gioHang = [];
  bool _isLoading = true;
  Set<int> _sanPhamDuocChon = {};

  @override
  void initState() {
    super.initState();
    _taiGioHang();
  }

  Future<void> _taiGioHang() async {
    gioHang = await GioHangService.layGioHang(widget.nguoiDungId);
    setState(() {
      _isLoading = false;
      _sanPhamDuocChon = gioHang.map((item) => item.id).toSet(); // mặc định chọn hết
    });
  }

  double _tinhTongTien() {
    return gioHang
        .where((item) => _sanPhamDuocChon.contains(item.id))
        .fold(0, (sum, item) => sum + item.gia * item.soLuong);
  }

  void _thayDoiSoLuong(int index, int thayDoi) async {
    final item = gioHang[index];
    final newQuantity = item.soLuong + thayDoi;
    if (newQuantity < 1) return;

    final thanhCong = await GioHangService.capNhatSoLuong(item.id, newQuantity);
    if (thanhCong) {
      await _taiGioHang();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật số lượng thất bại")),
      );
    }
  }

  void _xoaSanPham(int gioHangId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Xóa sản phẩm"),
        content: const Text("Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Hủy")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Xóa")),
        ],
      ),
    );

    if (confirm == true) {
      final thanhCong = await GioHangService.xoaKhoiGioHang(gioHangId);
      if (thanhCong) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("🗑️ Đã xóa sản phẩm khỏi giỏ hàng")),
        );
        await _taiGioHang();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Xóa thất bại")),
        );
      }
    }
  }

  bool get _daChonHet => _sanPhamDuocChon.length == gioHang.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giỏ hàng")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: gioHang.isEmpty
                      ? const Center(child: Text("Giỏ hàng trống"))
                      : ListView.builder(
                          itemCount: gioHang.length + 1, // +1 để thêm dòng chọn tất cả
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return CheckboxListTile(
                                value: _daChonHet,
                                onChanged: (chonHet) {
                                  setState(() {
                                    if (chonHet == true) {
                                      _sanPhamDuocChon = gioHang.map((item) => item.id).toSet();
                                    } else {
                                      _sanPhamDuocChon.clear();
                                    }
                                  });
                                },
                                title: const Text("Chọn tất cả sản phẩm"),
                                controlAffinity: ListTileControlAffinity.leading,
                              );
                            }

                            final item = gioHang[index - 1];
                            return ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (_sanPhamDuocChon.contains(item.id)) {
                                      _sanPhamDuocChon.remove(item.id);
                                    } else {
                                      _sanPhamDuocChon.add(item.id);
                                    }
                                  });
                                },
                                child: Icon(
                                  _sanPhamDuocChon.contains(item.id)
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_unchecked,
                                  color: Colors.green,
                                ),
                              ),
                              title: Text(item.tenSanPham),
                              subtitle: Text("${item.gia.toStringAsFixed(0)}đ x ${item.soLuong}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () => _thayDoiSoLuong(index - 1, -1),
                                  ),
                                  Text(item.soLuong.toString()),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () => _thayDoiSoLuong(index - 1, 1),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () => _xoaSanPham(item.id),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                SafeArea(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(blurRadius: 4, color: Colors.grey, offset: Offset(0, -2)),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Tổng tiền:", style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(
                              "${_tinhTongTien().toStringAsFixed(0)}đ",
                              style: const TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            final gioHangChon = gioHang
                                .where((item) => _sanPhamDuocChon.contains(item.id))
                                .toList();

                            if (gioHangChon.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("❗ Vui lòng chọn ít nhất 1 sản phẩm")),
                              );
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DatHangScreen(
                                  nguoiDungId: widget.nguoiDungId,
                                  gioHang: gioHangChon,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.pink,
                            minimumSize: const Size.fromHeight(45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Tiến hành đặt hàng"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
