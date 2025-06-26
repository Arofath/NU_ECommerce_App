import 'package:e_commerce/Models/product_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/product_detail_controller.dart';

class CustomColor extends StatelessWidget {
  CustomColor({super.key});

  final ProductDetailController controller =
      Get.find<ProductDetailController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.colors.asMap().entries.map((entry) {
            int index = entry.key;
            ProductColor productColor = entry.value;
            bool isSelected = controller.selectedColorIndex.value == index;

            return GestureDetector(
              onTap: () => controller.selectColor(index),
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: productColor.color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      );
    });
  }
}
