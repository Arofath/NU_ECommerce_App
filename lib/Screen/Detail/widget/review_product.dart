import 'package:e_commerce/Model/review_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Controllers/product_detail_controller.dart';

class ReviewProduct extends StatelessWidget {
  ReviewProduct({super.key});

  final ProductDetailController controller = Get.put(ProductDetailController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            for (int i = 0; i < 5; i++)
              Icon(
                Icons.star,
                size: 20,
                // color: i < (controller.product.value?.rating ?? 4.9)
                color: i < 4.9 ? Colors.orange : Colors.grey[300],
              ),
            const SizedBox(width: 8),
            const Text(
              //'${controller.product.value?.rating ?? 4.9}',
              '4.9',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              //' (${controller.product.value?.reviewCount ?? 5} Review)',
              ' (5 Reviews)',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Obx(() {
          if (controller.reviews.isEmpty) {
            return const SizedBox.shrink();
          }

          ReviewModel review = controller.reviews.first;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.person, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.userName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              for (int i = 0; i < 5; i++)
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: i < review.rating
                                      ? Colors.orange
                                      : Colors.grey[300],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  review.comment,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  review.date,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
