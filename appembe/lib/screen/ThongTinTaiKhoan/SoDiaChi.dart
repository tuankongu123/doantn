import 'package:appembe/screen/ThongTinTaiKhoan/SuaDiaChiScreen.dart';
import 'package:flutter/material.dart';
import 'package:appembe/screen/ThongTinTaiKhoan/ThemDiaChi.dart';
import 'package:appembe/services/DiaChiService.dart';

class SoDiaChiScreen extends StatefulWidget {
  const SoDiaChiScreen({super.key});

  @override
  State<SoDiaChiScreen> createState() => _SoDiaChiScreenState();
}

class _SoDiaChiScreenState extends State<SoDiaChiScreen> {
  List<Map<String, dynamic>> diaChiList = [];

  @override
  void initState() {
    super.initState();
    loadDiaChi();
  }

  Future<void> loadDiaChi() async {
    try {
      final ds = await DiaChiService.getDiaChi(
        1,
      ); // 👈 ID người dùng mặc định là 1
      setState(() {
        diaChiList = ds;
      });
    } catch (e) {
      print('Lỗi tải địa chỉ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sổ Địa Chỉ"), centerTitle: true),
      body: diaChiList.isEmpty
          ? const Center(child: Text("Chưa có địa chỉ nào"))
          : ListView.builder(
              itemCount: diaChiList.length,
              itemBuilder: (context, index) {
                final dc = diaChiList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.pink),
                    title: Text(
                      "${dc['tenNguoiNhan']}  |  ${dc['soDienThoai']}",
                    ),
                    subtitle: Text(dc['diaChi']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        dc['macDinh'] == true
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  border: Border.all(color: Colors.pink),
                                ),
                                child: const Text(
                                  "Địa chỉ mặc định",
                                  style: TextStyle(
                                    color: Colors.pink,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.grey),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SuaDiaChiScreen(diaChi: dc),
                              ),
                            );

                            if (result == true) {
                              await loadDiaChi();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ThemDiaChi()),
            );

            if (result == true) {
              await loadDiaChi();
            }
          },
          icon: const Icon(Icons.add),
          label: const Text(
            "Thêm địa chỉ nhận hàng",
            style: TextStyle(color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
    );
  }
}
