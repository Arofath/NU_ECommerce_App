import 'package:e_commerce/Models/product.dart';
import 'package:e_commerce/Screen/Detail/detail_screen.dart';
import 'package:e_commerce/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<String> product = [
    "Nike Air Max",
    "Adidas Ultra Boost",
    "Puma Running",
    "Reebok Classic",
    "New Balance 550",
    "Asics Gel",
  ];

  final List<Product> allProducts;

  CustomSearchDelegate({required this.allProducts});

  // 🔷 This gives the custom design to the search bar
  @override
  InputDecorationTheme get searchFieldDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.lightBlue, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.lightBlue, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  @override
  String? get searchFieldLabel => 'Nike Air Max';

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back, color: Colors.grey),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear, color: Colors.grey),
      ),
      const Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: Icon(Icons.mic, color: Colors.grey),
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    final matchQuery = allProducts
        .where((product) =>
            product.productName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final product = matchQuery[index];
        return ListTile(
          leading: const Icon(Icons.shopping_bag),
          title: Text(product.productName),
          subtitle: Text("\$${product.price.toStringAsFixed(2)}"),
          onTap: () {
            close(context, null);
            Get.to(() => DetailScreen(product: product));
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final matchQuery = allProducts
        .where((product) =>
            product.productName.toLowerCase().contains(query.toLowerCase()))
        .take(5)
        .toList(); // ✅ Limit suggestions to 5

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        final product = matchQuery[index];
        return ListTile(
          leading: const Icon(Icons.search),
          title: Text(product.productName),
          onTap: () {
            query = product.productName;
            close(context, null);
            Get.to(
                () => DetailScreen(product: product)); // ✅ Navigate to detail
          },
        );
      },
    );
  }
}
