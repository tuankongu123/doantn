import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<void> _chonVaTaiLenFile() async {
    setState(() {
      _loiDong = [];
      _tenFile = null;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _tenFile = result.files.single.name;
        });
        File file = File(result.files.single.path!);
        await _uploadFile(file);
      } else {
        _showSnackBar("Không chọn file nào");
      }
    } catch (e) {
      _showSnackBar("Lỗi khi chọn file: ${e.toString()}");
    }
  }

  Future<void> _uploadFile(File file) async {
    setState(() {
      _dangUpload = true;
      _loiDong = [];
    });

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2/app_api/SanPham/upload_excel.php'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: _tenFile,
        ),
      );

      var response = await request.send();
      final responseData = await response.stream.bytesToString();
      final jsonResult = jsonDecode(responseData);

      if (response.statusCode == 200) {
        if (jsonResult['status'] == 'success') {
          _handleSuccess();
        } else {
          _handleErrors(jsonResult);
        }
      } else {
        _showSnackBar(
          "Lỗi máy chủ (${response.statusCode}): ${jsonResult['message'] ?? 'Không có thông báo lỗi'}",
        );
      }
    } on SocketException {
      _showSnackBar("Lỗi kết nối mạng. Vui lòng kiểm tra kết nối internet");
    } on HttpException catch (e) {
      _showSnackBar("Lỗi HTTP: ${e.message}");
    } on FormatException {
      _showSnackBar("Lỗi định dạng dữ liệu từ server");
    } catch (e) {
      _showSnackBar("Lỗi không xác định: ${e.toString()}");
    } finally {
      setState(() {
        _dangUpload = false;
      });
    }
  }

  void _handleSuccess() {
    if (widget.onThemXong != null) widget.onThemXong!();
    _showSnackBar("Nhập sản phẩm thành công!", isError: false);
    Navigator.pop(context);
  }

  void _handleErrors(Map<String, dynamic> jsonResult) {
    setState(() {
      if (jsonResult['errors'] != null && jsonResult['errors'] is List) {
        _loiDong = List<Map<String, dynamic>>.from(jsonResult['errors']);
      } else {
        _loiDong = [
          {'dong': '?', 'loi': jsonResult['message'] ?? 'Lỗi không xác định'},
        ];
      }
    });
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nhập sản phẩm từ Excel"),
        actions: [
          if (_dangUpload)
            const Padding(
              padding: EdgeInsets.all(12.0),
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
            if (_tenFile != null) ...[
              Text(
                "File đã chọn: $_tenFile",
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
            if (_loiDong.isNotEmpty) ...[
              const Divider(height: 20),
              const Text(
                "Chi tiết lỗi:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Card(
                  elevation: 2,
                  child: ListView.separated(
                    itemCount: _loiDong.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final error = _loiDong[index];
                      return ListTile(
                        leading: const Icon(Icons.error, color: Colors.red),
                        title: Text("Dòng ${error['dong']}"),
                        subtitle: Text(error['loi'].toString()),
                        dense: true,
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
