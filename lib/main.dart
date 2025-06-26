import 'package:e_commerce/Controllers/auth_controller.dart';
import 'package:e_commerce/Screen/SplashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'Controllers/cart_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register controller once
  Get.put(AuthController());
  //Get.put(CartController());
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce Application',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      initialBinding: BindingsBuilder(() {
        Get.put(CartController());
      }),
    );
  }
}
