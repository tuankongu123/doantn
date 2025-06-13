import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Baner extends StatefulWidget {
  const Baner({super.key});

  @override
  State<Baner> createState() => _BanerState();
}

class _BanerState extends State<Baner> {
  int _currentIndex = 0;

  // 🔁 Danh sách ảnh local
  final List<String> _banners = [
    'baner/1.webp',
    'baner/2.webp',
    'baner/3.webp',
    'baner/4.webp',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 📸 Carousel từ ảnh local
        CarouselSlider(
          items: _banners.map((assetPath) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                assetPath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          }).toList(),
          options: CarouselOptions(
            height: 150,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ),

        // 🔘 Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _banners.asMap().entries.map((entry) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(
                horizontal: 4.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? Colors.black
                    : Colors.grey[300],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
