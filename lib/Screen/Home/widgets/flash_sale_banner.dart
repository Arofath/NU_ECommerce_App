import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/Controllers/flash_sale_controller.dart';
import 'package:e_commerce/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FlashSaleBanner extends StatelessWidget {
  FlashSaleBanner({super.key});

  final controller = Get.put(FlashSaleController());

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FlashSaleController());

    final List<String> bannerImages = [
      "images/flash_sale.jpg",
      "images/bruno marc black friday 01.jpg",
      "images/flashsale45_87f5d41e-7761-4763-9.jpg",
    ];

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: bannerImages.length,
          itemBuilder: (context, index, realIdx) {
            return _buildBanner(bannerImages[index]);
          },
          options: CarouselOptions(
            height: 200,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayAnimationDuration: const Duration(seconds: 1),
            onPageChanged: (index, reason) {
              controller.setIndex(index);
            },
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(bannerImages.length, (index) {
              bool isActive = controller.currentIndex.value == index;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: 10,
                width: isActive ? 15 : 15,
                decoration: BoxDecoration(
                  color: isActive ? primaryColor : Colors.grey,
                  //borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.circle,
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _liveCountdown() {
    return Obx(() {
      final duration = controller.remainingTime.value;
      final h = controller.formatTimeUnit(duration.inHours);
      final m = controller.formatTimeUnit(duration.inMinutes % 60);
      final s = controller.formatTimeUnit(duration.inSeconds % 60);

      return Row(
        children: [
          _timeBox(h),
          const SizedBox(width: 4),
          const Text(":", style: TextStyle(color: Colors.white)),
          const SizedBox(width: 4),
          _timeBox(m),
          const SizedBox(width: 4),
          const Text(":", style: TextStyle(color: Colors.white)),
          const SizedBox(width: 4),
          _timeBox(s),
        ],
      );
    });
  }

  Widget _timeBox(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        time,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: darkColor,
        ),
      ),
    );
  }

  Widget _buildBanner(String imagePath) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.black.withOpacity(0.3),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _liveCountdown(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
