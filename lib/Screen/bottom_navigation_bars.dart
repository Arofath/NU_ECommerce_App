import 'package:e_commerce/Controllers/cart_controller.dart';
import 'package:e_commerce/Screen/Cart/cart_screen.dart';
import 'package:e_commerce/Screen/Home/home_page.dart';
import 'package:e_commerce/Screen/Profile/profile_screen.dart';
import 'package:e_commerce/Screen/favorite/favorite_screen.dart';
import 'package:e_commerce/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:get/get.dart';

class BottomNavigationBars extends StatefulWidget {
  const BottomNavigationBars({super.key});

  @override
  State<BottomNavigationBars> createState() => _BottomNavigationBarsState();
}

class _BottomNavigationBarsState extends State<BottomNavigationBars> {
  final CartController cartController = Get.put(CartController());

  int _selectedIndex = 0;
  final _widgetOption = [
    const HomePage(),
    const CartScreen(),
    const FavoriteScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOption[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                size: 30,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
            icon: Obx(() {
              final cartCount = cartController.cartItems.length;

              return badges.Badge(
                showBadge: cartCount > 0,
                badgeContent: Text(
                  cartCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Colors.red,
                  padding: EdgeInsets.all(6),
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 30,
                ),
              );
            }),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite_border_outlined,
                size: 30,
              ),
              label: 'Favorite'),
          const BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              size: 30,
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
