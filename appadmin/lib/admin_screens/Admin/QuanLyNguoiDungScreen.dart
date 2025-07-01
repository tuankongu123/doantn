import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appadmin/admin_services/NguoiDungServices.dart';
import '../../models/nguoi_dung_model.dart';

class AdminQuanLyNguoiDungScreen extends StatefulWidget {
  const AdminQuanLyNguoiDungScreen({super.key});

  @override
  State<AdminQuanLyNguoiDungScreen> createState() =>
      _AdminQuanLyNguoiDungScreenState();
}

class _AdminQuanLyNguoiDungScreenState
    extends State<AdminQuanLyNguoiDungScreen> {
  List<NguoiDung> _dsNguoiDung = [];
  bool _isLoading = true;
  final _sdtController = TextEditingController();
  String _tuKhoa = '';
  String _locVaiTro = 'Tất cả';
  String _locTrangThai = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _loadNguoiDung();
  }

  @override
  void dispose() {
    _sdtController.dispose();
    super.dispose();
  }

  void _loadNguoiDung() async {
    try {
      final data = await NguoiDungService.fetchAll();
      setState(() {
        _dsNguoiDung = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Lỗi tải dữ liệu: $e", isError: true);
    }
  }

  void _capNhatVaiTro(NguoiDung nd, String vaiTroMoi) async {
    if (nd.vaiTro == vaiTroMoi) {
      _showSnackBar("Tài khoản đã là $vaiTroMoi rồi!", isError: true);
      return;
    }

    try {
      await NguoiDungService.capNhatVaiTro(nd.id, vaiTroMoi);
      setState(() {
        final index = _dsNguoiDung.indexWhere((e) => e.id == nd.id);
        _dsNguoiDung[index] = NguoiDung(
          id: nd.id,
          hoTen: nd.hoTen,
          hinhAnh: nd.hinhAnh,
          soDienThoai: nd.soDienThoai,
          email: nd.email,
          vaiTro: vaiTroMoi,
          xacThuc: nd.xacThuc,
        );
      });
      _showSnackBar("Đã cập nhật vai trò thành $vaiTroMoi");
    } catch (e) {
      _showSnackBar("Lỗi cập nhật vai trò: $e", isError: true);
    }
  }

  void _capNhatXacThuc(NguoiDung nd, bool moiTrangThai) async {
    if (nd.xacThuc == moiTrangThai) {
      _showSnackBar(
        "Tài khoản đã ${moiTrangThai ? 'mở khóa' : 'bị khóa'} rồi!",
        isError: true,
      );
      return;
    }

    try {
      await NguoiDungService.capNhatXacThuc(nd.id, moiTrangThai);
      setState(() {
        final index = _dsNguoiDung.indexWhere((e) => e.id == nd.id);
        _dsNguoiDung[index] = NguoiDung(
          id: nd.id,
          hoTen: nd.hoTen,
          hinhAnh: nd.hinhAnh,
          soDienThoai: nd.soDienThoai,
          email: nd.email,
          vaiTro: nd.vaiTro,
          xacThuc: moiTrangThai,
        );
      });
      _showSnackBar(
        "Đã ${moiTrangThai ? 'mở khóa' : 'khóa'} tài khoản thành công!",
      );
    } catch (e) {
      _showSnackBar("Lỗi cập nhật trạng thái: $e", isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final dsLoc = _dsNguoiDung.where((nd) {
      final matchSDT = nd.soDienThoai.contains(_tuKhoa);
      final matchVaiTro = _locVaiTro == 'Tất cả' || nd.vaiTro == _locVaiTro;
      final matchTrangThai =
          _locTrangThai == 'Tất cả' ||
          (_locTrangThai == 'Đã xác thực' && nd.xacThuc) ||
          (_locTrangThai == 'Chưa xác thực' && !nd.xacThuc);
      return matchSDT && matchVaiTro && matchTrangThai;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Quản lý người dùng")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      TextField(
                        controller: _sdtController,
                        decoration: const InputDecoration(
                          labelText: 'Tìm theo số điện thoại',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          counterText: "", // Ẩn đếm ký tự
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        onChanged: (value) {
                          setState(() => _tuKhoa = value);
                        },
                      ),

                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _locVaiTro,
                              decoration: const InputDecoration(
                                labelText: 'Lọc vai trò',
                              ),
                              items: ['Tất cả', 'admin', 'user']
                                  .map(
                                    (v) => DropdownMenuItem(
                                      value: v,
                                      child: Text(v),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() => _locVaiTro = value!);
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _locTrangThai,
                              decoration: const InputDecoration(
                                labelText: 'Lọc trạng thái',
                              ),
                              items: ['Tất cả', 'Đã xác thực', 'Chưa xác thực']
                                  .map(
                                    (v) => DropdownMenuItem(
                                      value: v,
                                      child: Text(v),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() => _locTrangThai = value!);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: dsLoc.length,
                    itemBuilder: (context, index) {
                      final nd = dsLoc[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: nd.hinhAnh != null
                              ? NetworkImage(nd.hinhAnh!)
                              : null,
                          child: nd.hinhAnh == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(
                          nd.hoTen.isEmpty ? nd.soDienThoai : nd.hoTen,
                        ),
                        subtitle: Text(
                          "Email: ${nd.email ?? "(không có)"}\nVai trò: ${nd.vaiTro} | Xác thực: ${nd.xacThuc ? "✅" : "❌"}",
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'admin' || value == 'user') {
                              _capNhatVaiTro(nd, value);
                            } else if (value == 'khoa') {
                              _capNhatXacThuc(nd, false);
                            } else if (value == 'mo') {
                              _capNhatXacThuc(nd, true);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'admin',
                              child: Text("Phân quyền: Admin"),
                            ),
                            const PopupMenuItem(
                              value: 'user',
                              child: Text("Phân quyền: User"),
                            ),
                            const PopupMenuItem(
                              value: 'mo',
                              child: Text("Mở khóa"),
                            ),
                            const PopupMenuItem(
                              value: 'khoa',
                              child: Text("Khóa tài khoản"),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
