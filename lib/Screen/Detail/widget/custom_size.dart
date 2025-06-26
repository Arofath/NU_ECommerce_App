import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/product_detail_controller.dart';

class CustomSize extends StatelessWidget {
  CustomSize({super.key});
  final ProductDetailController controller =
      Get.find<ProductDetailController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.sizes.map((sizeObj) {
            bool isSelected = controller.selectedSize.value == sizeObj.size;
            return GestureDetector(
              onTap: () => controller.selectSize(sizeObj.size),
              child: Container(
                margin: const EdgeInsets.only(right: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.white,
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  sizeObj.size,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
