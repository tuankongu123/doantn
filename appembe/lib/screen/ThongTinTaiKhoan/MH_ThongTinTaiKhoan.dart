import 'package:appembe/screen/ThongTinTaiKhoan/DanhSachDonHangScreen.dart';
import 'package:appembe/screen/ThongTinTaiKhoan/SoBeYeu.dart';
import 'package:appembe/screen/ThongTinTaiKhoan/ThemBeYeuScreen.dart';
import 'package:flutter/material.dart';
import 'package:appembe/model/NguoiDungModel.dart';
import 'package:appembe/screen/ThongTinTaiKhoan/SoDiaChi.dart';
import 'package:appembe/screen/ThongTinTaiKhoan/ThongTinCaNhan.dart';
import 'package:appembe/services/NguoiDungService.dart';

class MH_ThongTinTaiKhoan extends StatefulWidget {
  const MH_ThongTinTaiKhoan({super.key});

  @override
  State<MH_ThongTinTaiKhoan> createState() => _MH_ThongTinTaiKhoanState();
}

class _MH_ThongTinTaiKhoanState extends State<MH_ThongTinTaiKhoan> {
  NguoiDung? _nguoiDung;
  bool _isLoading = true;

  final List<Map<String, dynamic>> accountOptions = const [
    {'icon': Icons.person, 'label': 'Thông tin tài khoản'},
    {'icon': Icons.child_care, 'label': 'Thông tin của bé'},
    {'icon': Icons.list_alt, 'label': 'Quản lý đơn hàng'},
    {'icon': Icons.location_on, 'label': 'Sổ địa chỉ'},
    {'icon': Icons.notifications, 'label': 'Thông báo của tôi'},
    {'icon': Icons.rate_review, 'label': 'Nhận xét sản phẩm đã mua'},
    {'icon': Icons.visibility, 'label': 'Sản phẩm đã xem'},
    {'icon': Icons.favorite_border, 'label': 'Sản phẩm yêu thích'},
    {'icon': Icons.access_time, 'label': 'Sản phẩm mua sau'},
    {'icon': Icons.edit, 'label': 'Nhận xét của tôi'},
    {'icon': Icons.help_outline, 'label': 'Hỏi đáp'},
    {'icon': Icons.monetization_on, 'label': 'Kicoin'},
    {'icon': Icons.card_giftcard, 'label': 'Ví ưu đãi'},
    {'icon': Icons.delete_forever, 'label': 'Xóa tài khoản'},
  ];

  @override
  void initState() {
    super.initState();
    _taiThongTinNguoiDung();
  }

  void _taiThongTinNguoiDung() async {
    const int id = 1; // Tạm test cố định
    final nguoiDung = await NguoiDungService.layThongTinNguoiDung(id);

    if (mounted) {
      setState(() {
        _nguoiDung = nguoiDung;
        _isLoading = false;
      });
    }

    if (nguoiDung == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Không tìm thấy người dùng")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 🔷 Header thông tin người dùng
                Container(
                  color: Colors.lightBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 32, color: Colors.blue),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Xin chào',
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            _nguoiDung?.hoTen != null &&
                                    _nguoiDung!.hoTen!.isNotEmpty
                                ? _nguoiDung!.hoTen!
                                : 'Người dùng',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),

                // 📝 Danh sách chức năng tài khoản
                Expanded(
                  child: ListView.separated(
                    itemCount: accountOptions.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = accountOptions[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.lightBlueAccent,
                          child: Icon(
                            item['icon'],
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(item['label']),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          switch (item['label']) {
                            case 'Thông tin tài khoản':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ThongTinCaNhanScreen(),
                                ),
                              );
                              break;
                            case 'Quản lý đơn hàng':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DanhSachDonHang(
                                    nguoiDungId: _nguoiDung!.id!,
                                  ), // truyền ID người dùng
                                ),
                              );
                              break;

                            case 'Sổ địa chỉ':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      SoDiaChiScreen(nguoiDungId: 1),
                                ),
                              );
                              break;
                            case 'Thông tin của bé':
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SoBeYeuScreen(),
                                ),
                              );
                              break;
                              break;
                            default:
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Chọn: ${item['label']}'),
                                ),
                              );
                          }
                        },
                      );
                    },
                  ),
                ),

                // 📞 Tư vấn bán hàng
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.phone, color: Colors.lightBlue),
                      SizedBox(width: 8),
                      Text(
                        'Tư vấn bán hàng   ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '0969427271',
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
