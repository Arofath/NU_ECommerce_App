import 'package:get/get.dart';
import '../Models/product.dart';
import '../Service/product_service.dart';

class ProductController extends GetxController {
  final ProductService _service = ProductService();

  var products = <Product>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchProducts();
    super.onInit();
  }

  void fetchProducts() async {
    try {
      isLoading.value = true;
      final result = await _service.fetchProducts();
      products.assignAll(result.reversed.toList()); // reverse the order
    } catch (e) {
      Get.snackbar('Error', 'Could not load products');
    } finally {
      isLoading.value = false;
    }
  }

  List<Product> getRelatedProducts(String categoryId, String excludeProductId,
      {int count = 5}) {
    // Filter products in the same category but exclude the current one
    final related = products
        .where((p) =>
            p.categoryId == categoryId && p.productId != excludeProductId)
        .toList();

    // Shuffle and take up to `count` products
    related.shuffle();
    return related.take(count).toList();
  }
}
