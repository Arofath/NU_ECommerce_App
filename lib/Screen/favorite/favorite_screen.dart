import 'package:e_commerce/Controllers/favorite_controller.dart';
import 'package:e_commerce/Models/product.dart';
import 'package:e_commerce/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final FavoriteController favoriteController = Get.put(FavoriteController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(favoriteController),
      body: Obx(() {
        if (favoriteController.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF54C5F8)),
            ),
          );
        }

        if (favoriteController.error.isNotEmpty) {
          return _buildErrorWidget(favoriteController);
        }

        if (favoriteController.isEmpty) {
          return _buildEmptyWidget();
        }

        return const FavoriteContent();
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(FavoriteController favoriteController) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: backgroundColor,
      elevation: 0,
      title: Obx(() => Text(
            'Favorite Products (${favoriteController.favoriteCount})',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )),
      centerTitle: false,
      actions: [
        Obx(() {
          if (favoriteController.isEmpty) return const SizedBox();

          return PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onSelected: (value) {
              if (value == 'clear_all') {
                favoriteController.clearAllFavorites();
              } else if (value == 'statistics') {
                favoriteController.showStatistics();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'statistics',
                child: Row(
                  children: [
                    Icon(Icons.analytics, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Statistics'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear_all',
                child: Row(
                  children: [
                    Icon(Icons.clear_all, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Clear All', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildErrorWidget(FavoriteController favoriteController) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 80,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            favoriteController.error,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => favoriteController.refresh(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF54C5F8),
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Favorites Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start adding products to your favorites\nto see them here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteContent extends StatefulWidget {
  const FavoriteContent({super.key});

  @override
  State<FavoriteContent> createState() => _FavoriteContentState();
}

class _FavoriteContentState extends State<FavoriteContent> {
  final RxString _searchQuery = ''.obs;
  final RxString _sortBy = 'name'.obs; // name, price_asc, price_desc, rating
  final FavoriteController favoriteController = Get.find<FavoriteController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildSearchAndFilter(),
        Expanded(child: _buildFavoritesList()),
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: (value) => _searchQuery.value = value,
            decoration: InputDecoration(
              hintText: 'Search favorites...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          const SizedBox(height: 12),

          // Sort Options
          Row(
            children: [
              const Text('Sort by: ',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(() => Row(
                        children: [
                          _buildSortChip('Name', 'name'),
                          _buildSortChip('Price ↑', 'price_asc'),
                          _buildSortChip('Price ↓', 'price_desc'),
                          _buildSortChip('Rating', 'rating'),
                        ],
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy.value == value;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 12,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) => _sortBy.value = value,
        backgroundColor: Colors.grey[200],
        selectedColor: const Color(0xFF54C5F8),
        checkmarkColor: Colors.white,
      ),
    );
  }

  Widget _buildFavoritesList() {
    return Obx(() {
      List<Product> products = _getFilteredAndSortedProducts();

      return Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65,
            crossAxisSpacing: 12.5,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return _buildProductCard(products[index]);
          },
        ),
      );
    });
  }

  List<Product> _getFilteredAndSortedProducts() {
    List<Product> products;

    // Apply sorting
    switch (_sortBy.value) {
      case 'name':
        products = favoriteController.getFavoritesSortedByName();
        break;
      case 'price_asc':
        products = favoriteController.getFavoritesSortedByPriceAsc();
        break;
      case 'price_desc':
        products = favoriteController.getFavoritesSortedByPriceDesc();
        break;
      case 'rating':
        products = favoriteController.getFavoritesSortedByRating();
        break;
      default:
        products = favoriteController.favoriteProducts;
    }

    // Apply search filter
    if (_searchQuery.value.isNotEmpty) {
      final lowerQuery = _searchQuery.value.toLowerCase();
      products = products
          .where((product) =>
              product.productName.toLowerCase().contains(lowerQuery) ||
              (product.description?.toLowerCase().contains(lowerQuery) ??
                  false))
          .toList();
    }

    return products;
  }

  Widget _buildProductCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Section
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Stack(
              children: [
                // Product Image
                Center(
                  child:
                      product.imageUrl != null && product.imageUrl!.isNotEmpty
                          ? Image.network(
                              product.fullImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _getProductIcon(product.productName),
                            )
                          : _getProductIcon(product.productName),
                ),
                // Heart Icon
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product Details Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.productName,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Rating Stars
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        return Icon(
                          index < product.rating.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color(0xFFFFB800),
                          size: 14,
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Price Section
                  Row(
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF54C5F8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Original Price and Discount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (product.oldPrice != null) ...[
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                '\$${product.oldPrice!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 6),
                              if (product.discountPercent != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${product.discountPercent!.toInt()}% Off',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ] else
                        const Spacer(),
                      GestureDetector(
                        onTap: () => favoriteController
                            .removeFromFavorites(product.productId),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.delete_outlined,
                            color: Colors.grey[600],
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProductIcon(String productName) {
    if (productName.toLowerCase().contains('bag')) {
      return Icon(
        Icons.work_outline,
        size: 60,
        color: Colors.grey[400],
      );
    } else {
      return Image.asset(
        "images/AIR+FORCE+1+'07.png",
        errorBuilder: (context, error, stackTrace) => Icon(
          Icons.image_not_supported,
          size: 60,
          color: Colors.grey[400],
        ),
      );
    }
  }
}
