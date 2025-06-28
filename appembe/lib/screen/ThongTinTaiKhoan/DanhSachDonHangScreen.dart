import 'package:flutter/material.dart';
import 'package:appembe/model/donhang_model.dart';
import 'package:appembe/services/DonHangServices.dart';

class DanhSachDonHang extends StatefulWidget {
  final int nguoiDungId; // ✅ dùng id

  const DanhSachDonHang({super.key, required this.nguoiDungId});

  @override
  State<DanhSachDonHang> createState() => _DanhSachDonHangState();
}

class _DanhSachDonHangState extends State<DanhSachDonHang>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<List<DonHang>> _futureOrders;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _futureOrders = DonHangServices().getDonHangByNguoiDungId(
      widget.nguoiDungId,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<DonHang> _filterByTrangThai(List<DonHang> list, String status) {
    return list.where((e) => e.trangThai == status).toList();
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')} VNĐ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý đơn hàng'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Chờ duyệt'),
            Tab(text: 'Đang giao'),
            Tab(text: 'Đã xong'),
            Tab(text: 'Đã hủy'),
          ],
        ),
      ),
      body: FutureBuilder<List<DonHang>>(
        future: _futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Lỗi khi tải đơn hàng."));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Không có đơn hàng nào."));
          }

          final allOrders = snapshot.data!;
          final List<List<DonHang>> tabs = [
            _filterByTrangThai(allOrders, 'cho_duyet'),
            _filterByTrangThai(allOrders, 'dang_giao'),
            _filterByTrangThai(allOrders, 'da_xong'),
            _filterByTrangThai(allOrders, 'huy'),
          ];

          return TabBarView(
            controller: _tabController,
            children: tabs.map((orders) {
              if (orders.isEmpty) {
                return const Center(
                  child: Text("Không có đơn nào trong trạng thái này."),
                );
              }

              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final don = orders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.receipt_long_rounded,
                        color: Colors.lightBlue,
                      ),
                      title: Text('Mã đơn: ${don.id}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Ngày đặt: ${don.ngayTao}'),
                          Text('Tổng tiền: ${_formatCurrency(don.tongTien)}'),
                          ElevatedButton(
                            onPressed: () {
                              //Đổi trạng thái hủy đơn hàng
                            },
                            child: Text('Hủy đơn'),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16.0),
                      onTap: () {
                        // TODO: chuyển sang chi tiết đơn hàng nếu cần
                      },
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
