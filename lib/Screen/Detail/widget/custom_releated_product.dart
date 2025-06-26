import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/Controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/product_detail_controller.dart';
import '../../../Models/product.dart';
import '../detail_screen.dart';

class CustomReleatedProduct extends StatelessWidget {
  CustomReleatedProduct({super.key, required this.product});

  final Product product;
  final ProductDetailController controller = Get.put(ProductDetailController());
  final ProductController productController = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    final relatedProducts = productController.getRelatedProducts(
      product.categoryId,
      product.productId,
      count: 5,
    );
    return SizedBox(
      height: 204,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: relatedProducts.length,
        itemBuilder: (context, index) {
          final relatedProduct = relatedProducts[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                Get.to(() => DetailScreen(product: product));
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: relatedProduct.imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: relatedProduct.imageUrl!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.image_not_supported_outlined,
                              size: 100,
                              color: Colors.grey[400],
                            ),
                          )
                        : Icon(
                            Icons.image_not_supported_outlined,
                            size: 100,
                            color: Colors.grey[400],
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          relatedProduct.productName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          //product.price,
                          '\$${relatedProduct.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              //product.originalPrice,
                              '\$${relatedProduct.oldPrice?.toStringAsFixed(2) ?? ""}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              //product.discount,
                              '${relatedProduct.discountPercent ?? 0}% Off',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
