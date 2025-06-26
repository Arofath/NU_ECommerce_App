import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/cart_item_with_product.dart';
import '../Models/cart.dart';

class CartService {
  final String baseUrl = 'http://10.0.2.2:8000/api';

  Future<Cart> getOrCreateUserCart() async {
    final response = await http.get(Uri.parse('$baseUrl/cart'));
    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get cart');
    }
  }

  Future<List<CartItemWithProduct>> fetchCartItems(String cartId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/cart-items?cart_id=$cartId'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => CartItemWithProduct.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load cart items');
    }
  }

  Future<CartItemWithProduct> addCartItem(
    String cartId,
    String productId,
    int quantity,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart-items'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'cart_id': cartId,
        'product_id': productId,
        'quantity': quantity,
      }),
    );

    if (response.statusCode == 201) {
      return CartItemWithProduct.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add cart item');
    }
  }

  Future<CartItemWithProduct> updateCartItemQuantity(
      String cartItemId, int change) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/cart-items/$cartItemId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'change': change}),
    );

    if (response.statusCode == 200) {
      return CartItemWithProduct.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update quantity');
    }
  }
}
