import 'package:e_commerce/Screen/Home/widgets/category_list.dart';
import 'package:e_commerce/Screen/Home/widgets/custom_card.dart';
import 'package:e_commerce/Screen/Home/widgets/flash_sale_banner.dart';
import 'package:e_commerce/Screen/Home/widgets/recommend_product.dart';
import 'package:e_commerce/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controllers/product_controller.dart';
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_grid_card.dart';
//import 'widgets/custom_grid_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductController productController = Get.put(ProductController());
  final TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(controller: searchController),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              FlashSaleBanner(),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                  Text(
                    "More Category",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              CategoryList(),
              const SizedBox(height: 18),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Flash Sale",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                  Text(
                    "See More",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (productController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (productController.products.isEmpty) {
                  return const Center(child: Text("No products available."));
                }
                return Container(
                  height: 326,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productController.products.length,
                    itemBuilder: (context, index) {
                      final product = productController.products[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 5),
                        child: CustomCard(product: product),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 18),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mage Sale",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: darkColor,
                    ),
                  ),
                  Text(
                    "See Moreg",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Obx(() {
                if (productController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (productController.products.isEmpty) {
                  return const Center(child: Text("No products available."));
                }

                // Shuffle a copy of the list
                final randomProducts = List.of(productController.products)
                  ..shuffle();

                return Container(
                  height: 326,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: randomProducts.length,
                    itemBuilder: (context, index) {
                      final product = randomProducts[index];
                      return Padding(
                        padding: const EdgeInsets.only(left: 12, bottom: 5),
                        child: CustomCard(product: product),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 15),
              const RecommendProductBanner(),
              const SizedBox(height: 12),
              Obx(() {
                if (productController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (productController.products.isEmpty) {
                  return const Center(child: Text("No products found"));
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.0,
                      crossAxisSpacing: 16.0,
                      childAspectRatio: 0.5, // Adjust as needed
                    ),
                    itemCount: productController.products.length,
                    itemBuilder: (context, index) {
                      return CustomGridCard(
                        product: productController.products[index],
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}


// actions: [
//           IconButton(
//             onPressed: () {
//               Get.defaultDialog(
//                 title: "Confirm Logout",
//                 middleText: "Are you sure you want to log out",
//                 textConfirm: "Yes",
//                 textCancel: "No",
//                 confirmTextColor: Colors.white,
//                 onConfirm: () {
//                   Get.back();
//                   authController.logout();
//                 },
//                 onCancel: () {},
//               );
//             },
//             icon: Icon(
//               Icons.login_outlined,
//             ),
//           ),
//         ],