import 'package:flutter/material.dart';

class BannerWidget extends StatelessWidget {
  BannerWidget({super.key});

  final List<String> bannerImages = [
    'assets/images/banner1.jpg',
    'assets/images/banner2.jpg',
    'assets/images/banner3.jpg',
    'assets/images/banner4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.yellow.shade900,
        ),
        child: PageView.builder(
          itemCount: bannerImages.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                bannerImages[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 140,
              ),
            );
          },
        ),
      ),
    );
  }
}
