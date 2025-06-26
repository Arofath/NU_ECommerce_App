import 'package:e_commerce/Models/product.dart';

class CartItemWithProduct {
  final String cartItemId;
  final String cartId;
  final int quantity;
  final DateTime addedAt;
  final Product product;

  CartItemWithProduct({
    required this.cartItemId,
    required this.cartId,
    required this.quantity,
    required this.addedAt,
    required this.product,
  });

  factory CartItemWithProduct.fromJson(Map<String, dynamic> json) {
    return CartItemWithProduct(
      cartItemId: json['cart_item_id'],
      cartId: json['cart_id'],
      quantity: json['quantity'],
      addedAt: DateTime.parse(json['added_at']),
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_item_id': cartItemId,
      'cart_id': cartId,
      'quantity': quantity,
      'added_at': addedAt.toIso8601String(),
      'product': product.toJson(),
    };
  }

  CartItemWithProduct copyWith({int? quantity}) {
    return CartItemWithProduct(
      cartItemId: cartItemId,
      cartId: cartId,
      quantity: quantity ?? this.quantity,
      addedAt: addedAt,
      product: product,
    );
  }
}
