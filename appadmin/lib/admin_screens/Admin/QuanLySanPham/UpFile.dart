import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

enum LoaiUpload { sanPham, loaiSanPham, voucher, khuyenMai }

class UploadExcelScreen extends StatefulWidget {
  final VoidCallback? onThemXong;
  const UploadExcelScreen({super.key, this.onThemXong});

  @override
  State<UploadExcelScreen> createState() => _UploadExcelScreenState();
}

class _UploadExcelScreenState extends State<UploadExcelScreen> {
  bool _dangUpload = false;
  List<Map<String, dynamic>> _loiDong = [];
  String? _tenFile;
  LoaiUpload _loaiDangChon = LoaiUpload.sanPham;

  Future<void> _chonVaTaiLenFile() async {
    setState(() {
      _loiDong = [];
      _tenFile = null;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        setState(() {
          _tenFile = result.files.single.name;
        });
        await _uploadFile(result.files.single);
      } else {
        _showSnackBar("Không chọn file nào");
      }
    } catch (e) {
      _showSnackBar("Lỗi khi chọn file: ${e.toString()}");
    }
  }

  Future<void> _uploadFile(PlatformFile file) async {
    setState(() {
      _dangUpload = true;
      _loiDong = [];
    });

    try {
      final loaiStr = _loaiDangChon.name;
      final uri = Uri.parse(
        'http://localhost/app_api/SanPham/upload_excel.php?type=$loaiStr',
      );

      var request = http.MultipartRequest('POST', uri);

      if (kIsWeb) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'file',
            file.bytes!,
            filename: file.name,
          ),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath('file', file.path!),
        );
      }

      var response = await request.send();
      final responseData = await response.stream.bytesToString();
      print("Phản hồi từ server: $responseData");

      final jsonResult = jsonDecode(responseData);

      if (response.statusCode == 200) {
        if (jsonResult['status'] == 'success') {
          _handleSuccess();
        } else {
          _handleErrors(jsonResult);
        }
      } else {
        _showSnackBar("Lỗi server (${response.statusCode})");
      }
    } catch (e) {
      _showSnackBar("Lỗi khi upload: $e");
    } finally {
      setState(() {
        _dangUpload = false;
      });
    }
  }

  void _handleSuccess() {
    if (widget.onThemXong != null) widget.onThemXong!();
    _showSnackBar("Tải dữ liệu thành công!", isError: false);
    Navigator.pop(context);
  }

  void _handleErrors(Map<String, dynamic> jsonResult) {
    setState(() {
      _loiDong =
          (jsonResult['errors'] as List?)
              ?.map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
              .toList() ??
          [
            {'dong': '?', 'loi': jsonResult['message'] ?? 'Lỗi không xác định'},
          ];
    });
  }

  void _taiFileMau() async {
    final loaiStr = _loaiDangChon.name;
    final url =
        'http://localhost/app_api/SanPham/download_template.php?type=$loaiStr';

    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      _showSnackBar("Không thể mở liên kết tải file mẫu.");
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  String _tenLoai(LoaiUpload loai) {
    switch (loai) {
      case LoaiUpload.sanPham:
        return 'Sản phẩm';
      case LoaiUpload.loaiSanPham:
        return 'Loại sản phẩm';
      case LoaiUpload.voucher:
        return 'Voucher';
      case LoaiUpload.khuyenMai:
        return 'Khuyến mãi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nhập dữ liệu từ Excel"),
        actions: [
          if (_dangUpload)
            const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<LoaiUpload>(
              value: _loaiDangChon,
              isExpanded: true,
              onChanged: (LoaiUpload? newValue) {
                if (newValue != null) {
                  setState(() {
                    _loaiDangChon = newValue;
                  });
                }
              },
              items: LoaiUpload.values.map((loai) {
                return DropdownMenuItem(
                  value: loai,
                  child: Text(_tenLoai(loai)),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            if (_tenFile != null) ...[
              Text(
                "Đã chọn: $_tenFile",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
            ],
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text("Chọn file Excel"),
              onPressed: _dangUpload ? null : _chonVaTaiLenFile,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text("Tải file mẫu"),
              onPressed: _dangUpload ? null : _taiFileMau,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            if (_loiDong.isNotEmpty) ...[
              const Divider(height: 20),
              const Text(
                "Chi tiết lỗi:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: ListView.separated(
                    itemCount: _loiDong.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final error = _loiDong[index];
                      return ListTile(
                        leading: const Icon(Icons.error, color: Colors.red),
                        title: Text("Dòng ${error['dong']}"),
                        subtitle: Text(error['loi'].toString()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
