import 'package:e_commerce/utils/helper.dart';
import 'package:flutter/material.dart';

class ProductColor {
  final String colorId;
  final String productId;
  final String colorHex; // contains named color here

  ProductColor({
    required this.colorId,
    required this.productId,
    required this.colorHex,
  });

  factory ProductColor.fromJson(Map<String, dynamic> json) {
    return ProductColor(
      colorId: json['color_id'],
      productId: json['product_id'],
      colorHex: json['colorHex'],
    );
  }

  Color get color {
    return parseColorName(colorHex);
  }
}
