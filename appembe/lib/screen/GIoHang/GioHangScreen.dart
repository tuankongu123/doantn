import 'package:appembe/services/GioHangServices.dart';
import 'package:flutter/material.dart';
import '../../model/GioHangModel.dart';

class GioHangScreen extends StatefulWidget {
  final int nguoiDungId;

  const GioHangScreen({super.key, required this.nguoiDungId});

  @override
  State<GioHangScreen> createState() => _GioHangScreenState();
}

class _GioHangScreenState extends State<GioHangScreen> {
  late Future<List<GioHangItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = GioHangService.fetchGioHang(widget.nguoiDungId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giỏ hàng")),
      body: FutureBuilder<List<GioHangItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Giỏ hàng trống"));
          }

          final gioHang = snapshot.data!;
          double tongTien = gioHang.fold(
            0,
            (sum, item) => sum + item.gia * item.soLuong,
          );

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: gioHang.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final item = gioHang[index];
                    return ListTile(
                      leading: Image.asset(
                        "assets/images/${item.hinhAnh}",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image_not_supported),
                      ),
                      title: Text(item.ten),
                      subtitle: Text(
                        "${item.gia.toStringAsFixed(0)}đ x ${item.soLuong}",
                        style: const TextStyle(color: Colors.red),
                      ),
                      trailing: Text(
                        "${(item.gia * item.soLuong).toStringAsFixed(0)}đ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.grey[200],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Tổng:", style: TextStyle(fontSize: 16)),
                    Text(
                      "${tongTien.toStringAsFixed(0)}đ",
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
