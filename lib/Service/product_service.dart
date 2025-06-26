import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/product.dart';

const baseUrl = 'http://10.0.2.2:8000/api/products';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
