import 'dart:convert';
import 'package:e_commerce/Models/product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class FavoriteController extends GetxController {
  static const String _favoritesKey = 'favorite_products';

  final GetStorage _storage = GetStorage();

  final RxList<Product> _favoriteProducts = <Product>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _error = ''.obs;

  // Getters
  List<Product> get favoriteProducts => _favoriteProducts.toList();
  bool get isLoading => _isLoading.value;
  String get error => _error.value;
  int get favoriteCount => _favoriteProducts.length;
  bool get isEmpty => _favoriteProducts.isEmpty;
  bool get isNotEmpty => _favoriteProducts.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  /// Load favorites from GetStorage
  Future<void> _loadFavorites() async {
    try {
      _setLoading(true);
      _clearError();

      final favoritesJson = _storage.read<List>(_favoritesKey) ?? [];

      _favoriteProducts.clear();
      for (var item in favoritesJson) {
        try {
          if (item is String) {
            final json = jsonDecode(item) as Map<String, dynamic>;
            _favoriteProducts.add(Product.fromJson(json));
          } else if (item is Map<String, dynamic>) {
            _favoriteProducts.add(Product.fromJson(item));
          }
        } catch (e) {
          print('Error parsing favorite product: $e');
        }
      }

      print('Loaded ${_favoriteProducts.length} favorite products');
    } catch (e) {
      _setError('Failed to load favorites: $e');
      print('Error loading favorites: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Save favorites to GetStorage
  Future<void> _saveFavorites() async {
    try {
      final favoritesJson =
          _favoriteProducts.map((product) => product.toJson()).toList();

      await _storage.write(_favoritesKey, favoritesJson);
      print('Saved ${_favoriteProducts.length} favorite products');
    } catch (e) {
      print('Error saving favorites: $e');
      _setError('Failed to save favorites: $e');
    }
  }

  /// Check if a product is in favorites
  bool isFavorite(String productId) {
    return _favoriteProducts.any((product) => product.productId == productId);
  }

  /// Add product to favorites
  Future<bool> addToFavorites(Product product) async {
    try {
      if (isFavorite(product.productId)) {
        print('Product ${product.productId} is already in favorites');
        return false;
      }

      _favoriteProducts.add(product);
      await _saveFavorites();

      // Show success message
      Get.snackbar(
        'Added to Favorites',
        '${product.productName} has been added to favorites',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF54C5F8),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      print('Added product ${product.productId} to favorites');
      return true;
    } catch (e) {
      _setError('Failed to add to favorites: $e');
      print('Error adding to favorites: $e');
      Get.snackbar(
        'Error',
        'Failed to add to favorites',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  /// Remove product from favorites
  Future<bool> removeFromFavorites(String productId) async {
    try {
      final product = _favoriteProducts.firstWhereOrNull(
        (product) => product.productId == productId,
      );

      if (product == null) {
        print('Product $productId was not in favorites');
        return false;
      }

      _favoriteProducts
          .removeWhere((product) => product.productId == productId);
      await _saveFavorites();

      // Show success message with undo option
      Get.snackbar(
        'Removed from Favorites',
        '${product.productName} has been removed from favorites',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF54C5F8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        mainButton: TextButton(
          onPressed: () {
            addToFavorites(product);
            Get.back(); // Close snackbar
          },
          child: const Text('UNDO', style: TextStyle(color: Colors.white)),
        ),
      );

      print('Removed product $productId from favorites');
      return true;
    } catch (e) {
      _setError('Failed to remove from favorites: $e');
      print('Error removing from favorites: $e');
      Get.snackbar(
        'Error',
        'Failed to remove from favorites',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  /// Toggle favorite status of a product
  Future<bool> toggleFavorite(Product product) async {
    if (isFavorite(product.productId)) {
      return await removeFromFavorites(product.productId);
    } else {
      return await addToFavorites(product);
    }
  }

  /// Clear all favorites
  Future<void> clearAllFavorites() async {
    try {
      // Show confirmation dialog
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Clear All Favorites'),
          content: const Text(
              'Are you sure you want to remove all products from favorites?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Clear All'),
            ),
          ],
        ),
      );

      if (result == true) {
        _favoriteProducts.clear();
        await _saveFavorites();

        Get.snackbar(
          'Favorites Cleared',
          'All favorites have been removed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF54C5F8),
          colorText: Colors.white,
        );

        print('Cleared all favorites');
      }
    } catch (e) {
      _setError('Failed to clear favorites: $e');
      print('Error clearing favorites: $e');
      Get.snackbar(
        'Error',
        'Failed to clear favorites',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Get favorite product by ID
  Product? getFavoriteById(String productId) {
    return _favoriteProducts.firstWhereOrNull(
      (product) => product.productId == productId,
    );
  }

  /// Get favorites by category
  RxList<Product> getFavoritesByCategory(String categoryId) {
    return _favoriteProducts
        .where((product) => product.categoryId == categoryId)
        .toList()
        .obs;
  }

  /// Get favorites sorted by price (ascending)
  RxList<Product> getFavoritesSortedByPriceAsc() {
    final sortedList = List<Product>.from(_favoriteProducts);
    sortedList.sort((a, b) => a.price.compareTo(b.price));
    return sortedList.obs;
  }

  /// Get favorites sorted by price (descending)
  RxList<Product> getFavoritesSortedByPriceDesc() {
    final sortedList = List<Product>.from(_favoriteProducts);
    sortedList.sort((a, b) => b.price.compareTo(a.price));
    return sortedList.obs;
  }

  /// Get favorites sorted by rating (descending)
  RxList<Product> getFavoritesSortedByRating() {
    final sortedList = List<Product>.from(_favoriteProducts);
    sortedList.sort((a, b) => b.rating.compareTo(a.rating));
    return sortedList.obs;
  }

  /// Get favorites sorted by name (alphabetical)
  RxList<Product> getFavoritesSortedByName() {
    final sortedList = List<Product>.from(_favoriteProducts);
    sortedList.sort((a, b) => a.productName.compareTo(b.productName));
    return sortedList.obs;
  }

  /// Refresh favorites (reload from storage)
  Future<void> refresh() async {
    await _loadFavorites();
  }

  /// Search favorites by name
  RxList<Product> searchFavorites(String query) {
    if (query.isEmpty) return _favoriteProducts;

    final lowerQuery = query.toLowerCase();
    return _favoriteProducts
        .where((product) =>
            product.productName.toLowerCase().contains(lowerQuery) ||
            (product.description?.toLowerCase().contains(lowerQuery) ?? false))
        .toList()
        .obs;
  }

  /// Get statistics
  Map<String, dynamic> getStatistics() {
    if (_favoriteProducts.isEmpty) {
      return {
        'totalProducts': 0,
        'averagePrice': 0.0,
        'averageRating': 0.0,
        'totalValue': 0.0,
        'categoriesCount': 0,
      };
    }

    final totalPrice = _favoriteProducts.fold<double>(
      0.0,
      (sum, product) => sum + product.price,
    );

    final totalRating = _favoriteProducts.fold<double>(
      0.0,
      (sum, product) => sum + product.rating,
    );

    final uniqueCategories =
        _favoriteProducts.map((product) => product.categoryId).toSet();

    return {
      'totalProducts': _favoriteProducts.length,
      'averagePrice': totalPrice / _favoriteProducts.length,
      'averageRating': totalRating / _favoriteProducts.length,
      'totalValue': totalPrice,
      'categoriesCount': uniqueCategories.length,
    };
  }

  /// Show statistics dialog
  void showStatistics() {
    final stats = getStatistics();
    Get.dialog(
      AlertDialog(
        title: const Text('Favorites Statistics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatRow('Total Products', '${stats['totalProducts']}'),
            _buildStatRow('Average Price',
                '\$${stats['averagePrice'].toStringAsFixed(2)}'),
            _buildStatRow('Average Rating',
                '${stats['averageRating'].toStringAsFixed(1)} ⭐'),
            _buildStatRow(
                'Total Value', '\$${stats['totalValue'].toStringAsFixed(2)}'),
            _buildStatRow('Categories', '${stats['categoriesCount']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading.value = loading;
  }

  void _setError(String errorMessage) {
    _error.value = errorMessage;
  }

  void _clearError() {
    _error.value = '';
  }

  @override
  void onClose() {
    super.onClose();
  }
}
