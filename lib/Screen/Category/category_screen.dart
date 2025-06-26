import 'package:e_commerce/Screen/Home/widgets/custom_grid_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/product_controller.dart';
import '../../Theme/theme.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  final ProductController productController = Get.find<ProductController>();

  CategoryScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Obx(() {
          if (productController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredProducts = productController.products
              .where((product) => product.categoryId == categoryId)
              .toList();

          if (filteredProducts.isEmpty) {
            return Center(child: Text('No products found in this category'));
          }

          return GridView.builder(
            itemCount: filteredProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              childAspectRatio: 0.5,
            ),
            itemBuilder: (context, index) {
              return CustomGridCard(product: filteredProducts[index]);
            },
          );
        }),
      ),
    );
  }
}
