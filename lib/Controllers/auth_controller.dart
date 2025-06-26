import 'package:e_commerce/Screen/bottom_navigation_bars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../API/auth_api.dart';
import '../Screen/auth/sign_in_screen.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;

  // Save token to shared preferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Get Token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Remove token and logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Get.offAll(() => const SignInScreen());
    Get.snackbar(
      "Logged Out",
      "You have been successfully logged out.",
      backgroundColor: Colors.red.shade400,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      icon: const Icon(Icons.logout, color: Colors.white),
    );
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await AuthService().register(
        name,
        email,
        password,
        confirmPassword,
      );

      if (response.containsKey('token')) {
        Get.snackbar(
          "Success",
          "Registration successful. Please sign in.",
          backgroundColor: Colors.green.shade600,
          colorText: Colors.white,
        );
        Get.offAll(() => const SignInScreen());
      } else if (response.containsKey('errors')) {
        final errors = response['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first[0];
        Get.snackbar("Error", firstError,
            backgroundColor: Colors.red, colorText: Colors.white);
      } else {
        Get.snackbar("Error", response['message'] ?? 'Registration failed',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    if (isLoading.value) return;

    isLoading.value = true;

    try {
      final response = await AuthService().login(email, password);

      if (response.containsKey('token')) {
        await saveToken(response['token']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', response['user']['name']);

        Get.snackbar("Success", "Welcome back!",
            backgroundColor: Colors.green, colorText: Colors.white);

        Get.offAll(() => const BottomNavigationBars());
      } else {
        Get.snackbar(
            "Login Failed", response['message'] ?? "Invalid credentials",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e",
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }
}
