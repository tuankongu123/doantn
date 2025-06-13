import 'package:flutter/material.dart';

class TP_ThanhDieuHuong extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const TP_ThanhDieuHuong({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.cyan,
      unselectedItemColor: Colors.cyan[200],
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_none), label: ''),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
      ],
    );
  }
}
