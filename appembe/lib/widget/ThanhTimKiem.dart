import 'package:flutter/material.dart';

class TP_ThanhTimKiem extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController? controller;
  final void Function(String)? onSubmitted;

  const TP_ThanhTimKiem({super.key, this.controller, this.onSubmitted});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.pink[200],
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.cyan),
            ),
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(Icons.search, color: Colors.cyan),
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    onSubmitted: onSubmitted,
                    decoration: const InputDecoration(
                      hintText: 'Tìm sản phẩm',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart_outlined, color: Colors.cyan),
                  onPressed: () {
                    // TODO: xử lý giỏ hàng
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
