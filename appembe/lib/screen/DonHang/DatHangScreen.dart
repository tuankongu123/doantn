import 'package:appembe/services/DiaChiService.dart';
import 'package:flutter/material.dart';
import 'package:appembe/services/DonHangServices.dart';
import 'package:appembe/services/GioHangServices.dart';
import 'package:appembe/model/GioHangModel.dart';
import 'package:appembe/model/SoDiaChiModel.dart';
import 'package:appembe/screen/ThongTinTaiKhoan/SoDiaChi.dart';
import 'dart:convert';

class DatHangScreen extends StatefulWidget {
  final int nguoiDungId;
  final List<GioHangItem> gioHang;

  const DatHangScreen({
    super.key,
    required this.nguoiDungId,
    required this.gioHang,
  });

  @override
  State<DatHangScreen> createState() => _DatHangScreenState();
}

class _DatHangScreenState extends State<DatHangScreen> {
  SoDiaChi? diaChiMacDinh;
  String _phuongThucThanhToan = 'cod';
  bool _suDungTichDiem = false;
  int _diemTichLuy = 30000;

  @override
  void initState() {
    super.initState();
    _loadDiaChiMacDinh();
  }

  Future<void> _loadDiaChiMacDinh() async {
    try {
      final danhSachMap = await DiaChiService.getDiaChi(widget.nguoiDungId);
      List<SoDiaChi> danhSach = danhSachMap.map((e) => SoDiaChi.fromJson(e)).toList();
      if (danhSach.isNotEmpty) {
        danhSach.sort((a, b) => a.id.compareTo(b.id));
        setState(() {
          diaChiMacDinh = danhSach.first;
        });
      }
    } catch (e) {
      print('Lỗi lấy địa chỉ: $e');
    }
  }

  double get tongTien => widget.gioHang.fold(0, (sum, item) => sum + item.gia * item.soLuong);
  double get _phiVanChuyen => 23000;
  double get _giamVanChuyen => 23000;
  double get _tienTichDiem => _suDungTichDiem ? _diemTichLuy.toDouble() : 0;
  double get _tongThanhToan => tongTien + _phiVanChuyen - _giamVanChuyen - _tienTichDiem;

  void _datHang() async {
    if (diaChiMacDinh == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Vui lòng chọn địa chỉ giao hàng")),
      );
      return;
    }

    final danhSachMap = widget.gioHang.map((e) => e.toOrderJson()).toList();

    final response = await DonHangServices.taoDonHang(
      danhSachSanPham: danhSachMap,
      tongTien: _tongThanhToan,
      phuongThucTt: _phuongThucThanhToan,
      diaChiId: diaChiMacDinh!.id,
      diaChiChiTiet: {
        "tenNguoiNhan": diaChiMacDinh!.tenNguoiNhan,
        "soDienThoai": diaChiMacDinh!.soDienThoai,
        "diaChi": diaChiMacDinh!.diaChi,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        await GioHangService.xoaGioHangTheoNguoiDung(widget.nguoiDungId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Đặt hàng thành công")),
        );
        Navigator.popUntil(context, ModalRoute.withName("/"));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Lỗi: ${data['error']}")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Kết nối server thất bại")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Xác nhận đơn hàng")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (diaChiMacDinh != null) _thongTinNhanHang(diaChiMacDinh!),
            _hinhThucGiaoHang(),
            const Divider(height: 1),
            _danhSachSanPham(widget.gioHang),
            _chonPhuongThucThanhToan(),
            _chonUuDaiVaTichDiem(),
            _tongKetDonHang(_tongThanhToan, _datHang),
          ],
        ),
      ),
    );
  }

  Widget _thongTinNhanHang(SoDiaChi diaChi) => ListTile(
    leading: const Icon(Icons.location_on),
    title: Text("${diaChi.tenNguoiNhan} | ${diaChi.soDienThoai}"),
    subtitle: Text(diaChi.diaChi),
    trailing: TextButton(
      onPressed: () async {
        final ketQua = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SoDiaChiScreen(
              nguoiDungId: widget.nguoiDungId,
              isSelectMode: true,
            ),
          ),
        );
        if (ketQua != null && ketQua is SoDiaChi) {
          setState(() {
            diaChiMacDinh = ketQua;
          });
        }
      },
      child: const Text("Thay đổi"),
    ),
  );

  Widget _hinhThucGiaoHang() => ListTile(
    title: const Text("Giao hỏa tốc - Nhận trong 15-60 phút"),
    subtitle: const Text("Miễn phí", style: TextStyle(color: Colors.red)),
    trailing: const Icon(Icons.local_shipping_outlined),
  );

  Widget _danhSachSanPham(List<GioHangItem> gioHang) => Column(
    children: gioHang.map((sp) {
      return Column(
        children: [
          ListTile(
            leading: Image.asset("assets/images/${sp.hinhAnh}", width: 50),
            title: Text(sp.tenSanPham),
            subtitle: Text("${sp.gia.toStringAsFixed(0)}đ x ${sp.soLuong}"),
            trailing: Text(
              "${(sp.gia * sp.soLuong).toStringAsFixed(0)}đ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
        ],
      );
    }).toList(),
  );

  Widget _chonPhuongThucThanhToan() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text("Phương thức thanh toán", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      RadioListTile<String>(
        title: const Text("Thanh toán khi nhận hàng"),
        value: 'cod',
        groupValue: _phuongThucThanhToan,
        onChanged: (value) => setState(() => _phuongThucThanhToan = value!),
      ),
      RadioListTile<String>(
        title: const Text("Thanh toán online (ZaloPay, Momo...)"),
        value: 'vi',
        groupValue: _phuongThucThanhToan,
        onChanged: (value) => setState(() => _phuongThucThanhToan = value!),
      ),
    ],
  );

  Widget _chonUuDaiVaTichDiem() => Column(
    children: [
      ListTile(
        leading: const Icon(Icons.card_giftcard),
        title: const Text("Ưu đãi & Mã giảm giá"),
        trailing: TextButton(child: const Text("Chọn mã"), onPressed: () {}),
      ),
      SwitchListTile(
        title: Text("Tiền tích lũy ($_diemTichLuyđ)"),
        subtitle: Text("-${_tienTichDiem.toStringAsFixed(0)}đ"),
        value: _suDungTichDiem,
        onChanged: (value) => setState(() => _suDungTichDiem = value),
      ),
    ],
  );

  Widget _tongKetDonHang(double tong, VoidCallback onDatHang) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: const BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(blurRadius: 4, color: Colors.grey, offset: Offset(0, -2)),
      ],
    ),
    child: Column(
      children: [
        _dongTien("Tạm tính", tongTien),
        _dongTien("Phí vận chuyển", _phiVanChuyen),
        _dongTien("Giảm giá phí vận chuyển", -_giamVanChuyen),
        _dongTien("Tiền tích lũy", -_tienTichDiem),
        const Divider(),
        _dongTien("Tổng thanh toán", tong, isBold: true, color: Colors.red),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: onDatHang,
          child: const Text("Đặt hàng"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _dongTien(
    String label,
    double value, {
    bool isBold = false,
    Color? color,
  }) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold ? const TextStyle(fontWeight: FontWeight.bold) : null,
        ),
        Text("${value.toStringAsFixed(0)}đ", style: TextStyle(color: color)),
      ],
    ),
  );
}
