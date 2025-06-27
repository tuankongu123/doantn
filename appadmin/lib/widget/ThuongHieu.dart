import 'package:appadmin/admin_services/ThuongHieuServices.dart';
import 'package:flutter/material.dart';
import 'package:appadmin/models/ThuongHieuModel.dart';

class ThuongHieuListWidget extends StatefulWidget {
  const ThuongHieuListWidget({super.key});

  @override
  State<ThuongHieuListWidget> createState() => _ThuongHieuListWidgetState();
}

class _ThuongHieuListWidgetState extends State<ThuongHieuListWidget> {
  late Future<List<ThuongHieu>> _thuongHieuFuture;

  @override
  void initState() {
    super.initState();
    _thuongHieuFuture = ThuongHieuService.fetchThuongHieu();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ThuongHieu>>(
      future: _thuongHieuFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 60,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const SizedBox(
            height: 60,
            child: Center(child: Text("Lỗi tải thương hiệu")),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox(
            height: 60,
            child: Center(child: Text("Không có thương hiệu")),
          );
        }

        final thuongHieus = snapshot.data!;

        return SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: thuongHieus.length,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            itemBuilder: (context, index) {
              final th = thuongHieus[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Chip(
                  label: Text(th.ten),
                  backgroundColor: Colors.pink.shade50,
                  labelStyle: const TextStyle(color: Colors.pink),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
