import 'dart:convert';
import 'package:e_commerce/Models/product.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/cart_item.dart';

class CartController extends GetxController {
  static const String _cartKey = 'cart_items';

  // Observable list of cart items
  final RxList<CartItem> _cartItems = <CartItem>[].obs;

  // Shipping and import charges (you can make these configurable)
  final RxDouble _shippingCost = 5.99.obs;
  final RxDouble _importCharges = 0.0.obs;

  // Import tax configuration
  double _importTaxRate = 0.15; // 15% import tax rate
  double _customsDutyRate = 0.10; // 10% customs duty
  double _handlingFee = 25.0; // Fixed handling fee
  double _minimumImportValue = 100.0; // Minimum value to trigger import charges

  // Getters
  List<CartItem> get cartItems => _cartItems;
  int get itemCount => _cartItems.length;
  int get totalQuantity =>
      _cartItems.fold(0, (sum, item) => sum + item.quantity);

  // Calculate subtotal (items total)
  double get subtotal =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  // Calculate total price including shipping and import charges
  double get totalPrice =>
      subtotal + _shippingCost.value + calculateImportCharges();

  // Shipping and import costs getters
  double get shippingCost => _shippingCost.value;
  double get importCharges => calculateImportCharges();

  @override
  void onInit() {
    super.onInit();
    loadCartFromStorage();
  }

  // Add product to cart
  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      final existingItemIndex = _cartItems.indexWhere(
        (item) => item.productId == product.productId,
      );

      if (existingItemIndex != -1) {
        // Item already exists, update quantity
        _cartItems[existingItemIndex].quantity += quantity;
        _cartItems.refresh(); // Trigger UI update
      } else {
        // Add new item to cart
        final cartItem = CartItem.fromProduct(product, quantity: quantity);
        _cartItems.add(cartItem);
      }

      await _saveCartToStorage();

      // Show success message
      Get.snackbar(
        'Added to Cart',
        '${product.productName} added to your cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String productId) async {
    try {
      _cartItems.removeWhere((item) => item.productId == productId);
      await _saveCartToStorage();

      Get.snackbar(
        'Removed',
        'Item removed from cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove item from cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Update item quantity
  Future<void> updateQuantity(String productId, int newQuantity) async {
    try {
      if (newQuantity <= 0) {
        await removeFromCart(productId);
        return;
      }

      final itemIndex = _cartItems.indexWhere(
        (item) => item.productId == productId,
      );

      if (itemIndex != -1) {
        _cartItems[itemIndex].quantity = newQuantity;
        _cartItems.refresh(); // Trigger UI update
        await _saveCartToStorage();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update quantity',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Increase quantity
  Future<void> increaseQuantity(String productId) async {
    final item = _cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    if (item != null) {
      await updateQuantity(productId, item.quantity + 1);
    }
  }

  // Decrease quantity
  Future<void> decreaseQuantity(String productId) async {
    final item = _cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    if (item != null && item.quantity > 1) {
      await updateQuantity(productId, item.quantity - 1);
    } else if (item != null && item.quantity == 1) {
      await removeFromCart(productId);
    }
  }

  // Clear entire cart
  Future<void> clearCart() async {
    try {
      _cartItems.clear();
      await _saveCartToStorage();

      Get.snackbar(
        'Cart Cleared',
        'All items removed from cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Check if product is in cart
  bool isInCart(String productId) {
    return _cartItems.any((item) => item.productId == productId);
  }

  // Get quantity of specific product in cart
  int getProductQuantity(String productId) {
    final item = _cartItems.firstWhereOrNull(
      (item) => item.productId == productId,
    );
    return item?.quantity ?? 0;
  }

  // Save cart to SharedPreferences
  Future<void> _saveCartToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = _cartItems.map((item) => item.toJson()).toList();
      await prefs.setString(_cartKey, jsonEncode(cartJson));
    } catch (e) {
      print('Error saving cart to storage: $e');
    }
  }

  // Load cart from SharedPreferences
  Future<void> loadCartFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartString = prefs.getString(_cartKey);

      if (cartString != null) {
        final List<dynamic> cartJson = jsonDecode(cartString);
        final cartItems =
            cartJson.map((item) => CartItem.fromJson(item)).toList();

        _cartItems.assignAll(cartItems);
      }
    } catch (e) {
      print('Error loading cart from storage: $e');
    }
  }

  // Update shipping cost (if needed)
  void updateShippingCost(double cost) {
    _shippingCost.value = cost;
  }

  // Update import charges (if needed)
  void updateImportCharges(double charges) {
    _importCharges.value = charges;
  }

  // Calculate import charges based on cart subtotal
  double calculateImportCharges() {
    // If cart is empty or subtotal is below minimum, no import charges
    if (_cartItems.isEmpty || subtotal < _minimumImportValue) {
      return 0.0;
    }

    // Calculate import tax (percentage of subtotal)
    double importTax = subtotal * _importTaxRate;

    // Calculate customs duty (percentage of subtotal)
    double customsDuty = subtotal * _customsDutyRate;

    // Total import charges = import tax + customs duty + handling fee
    double totalImportCharges = importTax + customsDuty + _handlingFee;

    return totalImportCharges;
  }

  // Calculate detailed import charges breakdown
  Map<String, double> getImportChargesBreakdown() {
    if (_cartItems.isEmpty || subtotal < _minimumImportValue) {
      return {
        'importTax': 0.0,
        'customsDuty': 0.0,
        'handlingFee': 0.0,
        'total': 0.0,
      };
    }

    double importTax = subtotal * _importTaxRate;
    double customsDuty = subtotal * _customsDutyRate;
    double total = importTax + customsDuty + _handlingFee;

    return {
      'importTax': importTax,
      'customsDuty': customsDuty,
      'handlingFee': _handlingFee,
      'total': total,
    };
  }

  // Update import tax configuration
  void updateImportTaxRate(double rate) {
    // Rate should be between 0 and 1 (0% to 100%)
    if (rate >= 0 && rate <= 1) {
      _importTaxRate = rate;
    }
  }

  void updateCustomsDutyRate(double rate) {
    // Rate should be between 0 and 1 (0% to 100%)
    if (rate >= 0 && rate <= 1) {
      _customsDutyRate = rate;
    }
  }

  void updateHandlingFee(double fee) {
    if (fee >= 0) {
      _handlingFee = fee;
    }
  }

  void updateMinimumImportValue(double value) {
    if (value >= 0) {
      _minimumImportValue = value;
    }
  }
}
