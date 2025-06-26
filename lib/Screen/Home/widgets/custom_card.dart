import 'package:e_commerce/Models/product.dart';
import 'package:e_commerce/Screen/Detail/detail_screen.dart';
import 'package:e_commerce/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade50),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 5),
              blurRadius: 10,
              color: Colors.black.withOpacity(0.1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: greyColor.withOpacity(0.05),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: product.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: product.imageUrl!,
                        fit: BoxFit.contain,
                        height: 170,
                        width: double.infinity,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image_not_supported_outlined,
                          size: 170,
                          color: greyColor,
                        ),
                      )
                    : const Icon(Icons.image, size: 170, color: greyColor),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.productName, // title
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            // Current Price
            Text(
              "\$${product.price}",
              style: const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 4),

            // Old Price + Discount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (product.oldPrice != null &&
                        product.oldPrice! > product.price)
                      Text(
                        "\$${product.oldPrice}",
                        style: const TextStyle(
                          fontSize: 13,
                          color: greyColor,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    const SizedBox(width: 10),
                    if (product.discountPercent != null)
                      Text(
                        "${product.discountPercent!.toStringAsFixed(0)}% off",
                        style: const TextStyle(
                          fontSize: 14,
                          color: secondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.shopping_cart_checkout_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
