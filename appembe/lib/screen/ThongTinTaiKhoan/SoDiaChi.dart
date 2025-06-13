// lib/screens/account/so_dia_chi_screen.dart
import 'package:appembe/screen/ThongTinTaiKhoan/ThemDiaChi.dart';
import 'package:flutter/material.dart';

class SoDiaChiScreen extends StatefulWidget {
  const SoDiaChiScreen({super.key});

  @override
  State<SoDiaChiScreen> createState() => _SoDiaChiScreenState();
}

class _SoDiaChiScreenState extends State<SoDiaChiScreen> {
  List<Map<String, dynamic>> diaChiList = [];

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
                return ListTile(
                  leading: Icon(Icons.location_on, color: Colors.pink),
                  title: Text("${dc['name']}  |  ${dc['phone']}"),
                  subtitle: Text(dc['address']),
                  trailing: dc['macDinh']
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
                            style: TextStyle(color: Colors.pink, fontSize: 12),
                          ),
                        )
                      : null,
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ThemDiaChiScreen(
                  onSave: (data) => setState(() => diaChiList.add(data)),
                ),
              ),
            );
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
