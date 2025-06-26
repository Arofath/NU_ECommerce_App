import 'package:get/get.dart';

import '../Model/related_product_model.dart';
import '../Model/review_model.dart';
import '../Models/product_color.dart';
import '../Models/product_size.dart';

class ProductDetailController extends GetxController {
  //var selectedSize = 8.obs;
  var isFavorite = false.obs;
  var relatedProducts = <RelatedProductModel>[].obs;
  var reviews = <ReviewModel>[].obs;

  // New
  var sizes = <ProductSize>[].obs;
  var selectedSize = ''.obs;
  var colors = <ProductColor>[].obs;
  var selectedColorIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    //loadRelatedProducts();
    loadReviews();
  }

  // Method to set sizes from a list of ProductSize objects
  void setSizes(List<ProductSize> newSizes) {
    sizes.value = newSizes;
    if (newSizes.isNotEmpty) {
      selectedSize.value = newSizes.first.size; // default select first size
    }
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }

  void setColors(List<ProductColor> newColors) {
    colors.value = newColors;
    if (newColors.isNotEmpty) selectedColorIndex.value = 0;
  }

  void selectColor(int index) {
    selectedColorIndex.value = index;
  }

  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }

  void loadReviews() async {
    // Simulate loading reviews
    reviews.value = [
      ReviewModel(
        userName: 'James Lawson',
        userImage:
            'https://static.vecteezy.com/system/resources/previews/048/216/761/non_2x/modern-male-avatar-with-black-hair-and-hoodie-illustration-free-png.png',
        rating: 5.0,
        comment:
            'air max are always very comfortable fit, clean and just perfect in every way. just the box was too small and scrunched the sneakers up a little bit. not sure if the box was always this small but the 90s are and will always be one of my favorites.',
        date: 'June 18, 2025',
      ),
    ];
  }
}
