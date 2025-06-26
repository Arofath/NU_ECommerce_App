import 'package:get/get.dart';
import '../Model/category_item.dart';
import '../Models/category.dart';
import '../Service/categories_service.dart';

class CategoryController extends GetxController {
  final categories = <CategoryItem>[].obs;
  final isLoading = false.obs;
  final apiCategories = <Category>[].obs;

  final CategoriesService _service = CategoriesService();

  String? getCategoryIdByName(String name) {
    return apiCategories
        .firstWhereOrNull((cat) => cat.categoryName == name)
        ?.categoryId;
  }

  final List<CategoryItem> _allStaticCategories = [
    CategoryItem(title: 'High Heels', icon: "images/Icon/high-heels.png"),
    CategoryItem(title: 'Dress', icon: "images/Icon/dress.png"),
    CategoryItem(title: 'Man Shirt', icon: "images/Icon/polo.png"),
    CategoryItem(title: 'Man Shoes', icon: "images/Icon/shoes.png"),
    CategoryItem(title: 'Man Bag', icon: "images/Icon/bag1.png"),
    CategoryItem(title: 'Woman Bag', icon: "images/Icon/handbag.png"),
  ];

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  void loadCategories() async {
    try {
      isLoading.value = true;
      final fetchedCategories = await _service.fetchCategories();
      apiCategories.assignAll(fetchedCategories);
      filterCategoriesFromApi(fetchedCategories);
    } catch (e) {
      Get.snackbar('Error', 'Could not load categories');
    } finally {
      isLoading.value = false;
    }
  }

  void filterCategoriesFromApi(List<Category> apiCategories) {
    final apiNames = apiCategories.map((c) => c.categoryName.trim()).toSet();

    final filtered = _allStaticCategories
        .where((item) => apiNames.contains(item.title.trim()))
        .toList();

    categories.assignAll(filtered);
  }
}
