import 'package:flutter/material.dart';
import '../model/DanhMucModel.dart';

class DanhMucWidget extends StatelessWidget {
  final List<DanhMuc> danhMucs;
  final int? selectedId;
  final Function(DanhMuc) onSelect;

  const DanhMucWidget({
    super.key,
    required this.danhMucs,
    required this.onSelect,
    this.selectedId,
  });

  Color getRandomColor(int index) {
    final colors = [
      Colors.amber.shade100,
      Colors.pink.shade100,
      Colors.cyan.shade100,
      Colors.blue.shade100,
      Colors.lime.shade100,
      Colors.green.shade100,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: danhMucs.length,
        itemBuilder: (context, index) {
          final item = danhMucs[index];
          final isSelected = item.id == selectedId;

          return GestureDetector(
            onTap: () => onSelect(item),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.blue.shade100
                    : getRandomColor(index),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? Colors.blue : Colors.grey.shade400,
                ),
              ),
              child: Center(
                child: Text(
                  item.ten,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.blue.shade900 : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
