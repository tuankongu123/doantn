import 'dart:convert';
import 'package:appembe/widget/DinhVi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GoiYDiaChi extends StatefulWidget {
  const GoiYDiaChi({super.key});

  @override
  State<GoiYDiaChi> createState() => _GoiYDiaChiState();
}

class _GoiYDiaChiState extends State<GoiYDiaChi> {
  final _controller = TextEditingController();
  List<String> _suggestions = [];
  bool _isLoading = false;

  Future<void> _fetchSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final apiKey = '061658ad0c2c4ca0a9791e41f821db39'; // 🔑 DÁN API KEY Ở ĐÂY
    final url =
        'https://api.geoapify.com/v1/geocode/autocomplete?text=$input&lang=vi&limit=5&filter=countrycode:vn&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final features = data['features'] as List;

        final List<String> results = features
            .map((f) => f['properties']['formatted'] as String)
            .toList();
        if (!mounted) return;
        setState(() {
          _suggestions = results;
        });
      }
    } catch (e) {
      debugPrint("Lỗi gọi API: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chọn địa chỉ")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: "Nhập số nhà, tên đường...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _fetchSuggestions(value);
              },
            ),
            const SizedBox(height: 12),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_suggestions[index]),
                          onTap: () {
                            Navigator.pop(context, _suggestions[index]);
                          },
                        );
                      },
                    ),
                  ),
            // ElevatedButton.icon(
            //   onPressed: () async {
            //     final diaChiBanDo = await Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) =>  DinhViTrenBanDo(),
            //       ),
            //     );
            //     if (diaChiBanDo != null) {
            //       Navigator.pop(context, diaChiBanDo);
            //     }
            //   },
            //   icon: const Icon(Icons.map),
            //   label: const Text("Chọn địa chỉ trên bản đồ"),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.white,
            //     foregroundColor: Colors.black,
            //     elevation: 0,
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //       side: const BorderSide(color: Colors.grey),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
