class ProductSize {
  final String sizeId;
  final String productId;
  final String size;

  ProductSize({
    required this.sizeId,
    required this.productId,
    required this.size,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      sizeId: json['size_id'],
      productId: json['product_id'],
      size: json['size'],
    );
  }
}
