import 'product_color.dart';
import 'product_size.dart';

class Product {
  final String productId;
  final String productName;
  final String? description;
  final double price;
  final double? oldPrice;
  final double? discountPercent;
  final String? imageUrl;
  final double rating;
  final String categoryId;
  final List<ProductColor> colors;
  final List<ProductSize> sizes;

  Product({
    required this.productId,
    required this.productName,
    this.description,
    required this.price,
    this.oldPrice,
    this.discountPercent,
    this.imageUrl,
    required this.rating,
    required this.categoryId,
    this.colors = const [],
    this.sizes = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      productName: json['product_name'],
      description: json['description'],
      price: double.parse(json['price'].toString()),
      oldPrice: json['oldPrice'] != null
          ? double.parse(json['oldPrice'].toString())
          : null,
      discountPercent: json['discountPercent'] != null
          ? double.parse(json['discountPercent'].toString())
          : null,
      imageUrl: json['imageUrl'],
      rating: double.parse(json['rating'].toString()),
      categoryId: json['category_id'],
      colors: (json['colors'] ?? [])
          .map<ProductColor>((c) => ProductColor.fromJson(c))
          .toList(),
      sizes: (json['sizes'] as List<dynamic>?)
              ?.map((e) => ProductSize.fromJson(e))
              .toList() ??
          [],
    );
  }

  String get fullImageUrl {
    if (imageUrl == null || imageUrl!.isEmpty) return '';
    return 'http://10.0.2.2:8000$imageUrl';
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'description': description,
      'price': price,
      'oldPrice': oldPrice,
      'discountPercent': discountPercent,
      'imageUrl': imageUrl,
      'rating': rating,
      'category_id': categoryId,
      // 'colors': colors.map((c) => c.toJson()).toList(),
      // 'sizes': sizes.map((s) => s.toJson()).toList(),
    };
  }
}
