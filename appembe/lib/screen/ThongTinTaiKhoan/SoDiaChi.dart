import 'package:flutter/material.dart';
import 'package:appembe/screen/ThongTinTaiKhoan/SuaDiaChiScreen.dart';
import 'package:appembe/screen/ThongTinTaiKhoan/ThemDiaChi.dart';
import 'package:appembe/services/DiaChiService.dart';
import 'package:appembe/model/SoDiaChiModel.dart';

class SoDiaChiScreen extends StatefulWidget {
  final bool isSelectMode;
  final int nguoiDungId;

  const SoDiaChiScreen({
    super.key,
    required this.nguoiDungId,
    this.isSelectMode = false,
  });

  @override
  State<SoDiaChiScreen> createState() => _SoDiaChiScreenState();
}

class _SoDiaChiScreenState extends State<SoDiaChiScreen> {
  List<Map<String, dynamic>> diaChiList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDiaChi();
  }

  Future<void> _loadDiaChi() async {
    setState(() => isLoading = true);
    try {
      final ds = await DiaChiService.getDiaChi(widget.nguoiDungId);
      setState(() => diaChiList = ds);
    } catch (e) {
      print('Lỗi tải địa chỉ: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải địa chỉ: ${e.toString()}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sổ Địa Chỉ"),
        centerTitle: true,
        actions: [
          if (widget.isSelectMode) ...[
            IconButton(
              icon: const Icon(Icons.add_location_alt),
              tooltip: "Thêm địa chỉ mới",
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ThemDiaChi()),
                );
                if (result == true) await _loadDiaChi();
              },
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ]
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: widget.isSelectMode ? null : _buildAddButton(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (diaChiList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text("Chưa có địa chỉ nào"),
            if (!widget.isSelectMode)
              TextButton(onPressed: _loadDiaChi, child: const Text("Thử lại")),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDiaChi,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: diaChiList.length,
        itemBuilder: (context, index) {
          final dc = diaChiList[index];
          return _buildDiaChiItem(dc);
        },
      ),
    );
  }

  Widget _buildDiaChiItem(Map<String, dynamic> diaChi) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: widget.isSelectMode
            ? () {
                final diaChiObj = SoDiaChi(
                  id: diaChi['id'],
                  nguoiDungId: diaChi['nguoiDungId'],
                  tenNguoiNhan: diaChi['tenNguoiNhan'],
                  soDienThoai: diaChi['soDienThoai'],
                  diaChi: diaChi['diaChi'],
                );
                Navigator.pop(context, diaChiObj);
              }
            : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.pink, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    diaChi['tenNguoiNhan'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  if (diaChi['macDinh'] == true)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.pink.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.pink),
                      ),
                      child: const Text(
                        "Mặc định",
                        style: TextStyle(color: Colors.pink, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(diaChi['soDienThoai'] ?? ''),
              const SizedBox(height: 4),
              Text(diaChi['diaChi'] ?? ''),
              if (!widget.isSelectMode) _buildActionButtons(diaChi),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> diaChi) {
    return Column(
      children: [
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton.icon(
              icon: const Icon(Icons.edit, size: 16),
              label: const Text("Sửa"),
              onPressed: () => _suaDiaChi(diaChi),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.grey[700],
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            const SizedBox(width: 8),
            if (diaChi['macDinh'] != true)
              ElevatedButton.icon(
                icon: const Icon(Icons.star, size: 16),
                label: const Text("Đặt mặc định"),
                onPressed: () => _datMacDinh(diaChi['id']),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.withOpacity(0.1),
                  foregroundColor: Colors.pink,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton.icon(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ThemDiaChi()),
            );
            if (result == true) await _loadDiaChi();
          },
          icon: const Icon(Icons.add),
          label: const Text("THÊM ĐỊA CHỊ MỚI"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _suaDiaChi(Map<String, dynamic> diaChi) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SuaDiaChiScreen(diaChi: diaChi)),
    );
    if (result == true) await _loadDiaChi();
  }

  Future<void> _datMacDinh(int id) async {
    try {
      await DiaChiService.datMacDinh(id);
      await _loadDiaChi();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã đặt làm địa chỉ mặc định")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi: ${e.toString()}")),
      );
    }
  }
}