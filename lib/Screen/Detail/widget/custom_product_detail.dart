import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/Controllers/favorite_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Models/product.dart';
import '../../../Theme/theme.dart';

class CustomProductDetail extends StatelessWidget {
  CustomProductDetail({super.key, required this.product});
  final Product product;
  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: greyColor.withOpacity(0.1),
          height: 250,
          width: double.infinity,
          child: Center(
            child: CachedNetworkImage(
              imageUrl: product.imageUrl ?? '',
              fit: BoxFit.cover,
              width: double.infinity,
              errorWidget: (context, url, error) {
                return Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.image,
                    size: 80,
                    color: Colors.red[300],
                  ),
                );
              },
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.productName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: darkColor,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Obx(
                      () => IconButton(
                        icon: Icon(
                          favoriteController.isFavorite(product.productId)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              favoriteController.isFavorite(product.productId)
                                  ? Colors.red
                                  : Colors.grey,
                        ),
                        onPressed: () {
                          favoriteController.toggleFavorite(product);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  if (index < product.rating.floor()) {
                    return const Icon(Icons.star,
                        size: 20, color: Colors.orange);
                  } else if (index < product.rating) {
                    return const Icon(Icons.star_half,
                        size: 20, color: Colors.orange);
                  } else {
                    return Icon(Icons.star_border,
                        size: 20, color: Colors.grey[300]);
                  }
                }),
              ),

              const SizedBox(height: 16),

              // Price
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
