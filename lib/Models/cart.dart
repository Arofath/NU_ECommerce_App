class Cart {
  final String cartId;
  final int userId;
  final DateTime createdAt;

  Cart({
    required this.cartId,
    required this.userId,
    required this.createdAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      cartId: json['cart_id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cart_id': cartId,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
