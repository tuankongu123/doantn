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

  @override
  void initState() {
    super.initState();
    _taiGioHang();
  }

  Future<void> _taiGioHang() async {
    gioHang = await GioHangService.layGioHang(widget.nguoiDungId);
    setState(() => _isLoading = false);
  }

  double _tinhTongTien() {
    return gioHang.fold(0, (sum, item) => sum + item.gia * item.soLuong);
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
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Xóa"),
          ),
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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("❌ Xóa thất bại")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giỏ hàng")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: gioHang.length,
                    itemBuilder: (context, index) {
                      final item = gioHang[index];
                      return ListTile(
                        leading: Image.asset(
                          "assets/images/${item.hinhAnh}",
                          width: 50,
                        ),
                        title: Text(item.tenSanPham),
                        subtitle: Text(
                          "${item.gia.toStringAsFixed(0)}đ x ${item.soLuong}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () => _thayDoiSoLuong(index, -1),
                            ),
                            Text(item.soLuong.toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _thayDoiSoLuong(index, 1),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () => _xoaSanPham(item.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 4,
                        color: Colors.grey,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tổng tiền:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${_tinhTongTien().toStringAsFixed(0)}đ",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DatHangScreen(
                                nguoiDungId: widget.nguoiDungId,
                                gioHang: gioHang, // 👈 Truyền danh sách gốc
                              ),
                            ),
                          );
                        },
                        child: const Text("Tiến hành đặt hàng"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          minimumSize: const Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
