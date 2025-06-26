import 'package:e_commerce/Models/product.dart';

class CartItem {
  final String productId;
  final String productName;
  final String? imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  // Convert CartItem to JSON for SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  // Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      productName: json['productName'],
      imageUrl: json['imageUrl'],
      price: double.parse(json['price'].toString()),
      quantity: int.parse(json['quantity'].toString()),
    );
  }

  // Create CartItem from Product
  factory CartItem.fromProduct(Product product, {int quantity = 1}) {
    return CartItem(
      productId: product.productId,
      productName: product.productName,
      imageUrl: product.imageUrl,
      price: product.price,
      quantity: quantity,
    );
  }

  // Calculate total price for this item
  double get totalPrice => price * quantity;

  @override
  String toString() {
    return 'CartItem{productId: $productId, productName: $productName, price: $price, quantity: $quantity}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          productId == other.productId;

  @override
  int get hashCode => productId.hashCode;
}
