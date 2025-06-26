import 'package:e_commerce/Controllers/auth_controller.dart';
import 'package:e_commerce/Screen/Profile/edit_profile.dart';
import 'package:e_commerce/Screen/about_us/about_us_screen.dart';
import 'package:e_commerce/Theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: Colors.black),
            onPressed: () {
              Get.defaultDialog(
                title: "Logout",
                titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                middleText: "Are you sure you want to log out?",
                textConfirm: "Yes",
                textCancel: "No",
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                cancelTextColor: Colors.grey[700],
                onConfirm: () {
                  Get.back(); // Close the dialog first
                  authController.logout();
                },
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Section
            Column(
              children: [
                // Profile Avatar
                CircleAvatar(
                  radius: 50,
                  child: ClipOval(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          "https://img.freepik.com/premium-vector/man-avatar-profile-picture-isolated-background-avatar-profile-picture-man_1293239-4841.jpg?semt=ais_hybrid&w=740",
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                FutureBuilder<String?>(
                  future: authController.getName(),
                  builder: (context, snapshot) {
                    final name = snapshot.data ?? 'Guest';
                    return Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
                // Name
                const SizedBox(height: 4),
                // Username
                FutureBuilder<String?>(
                  future: authController.getName(),
                  builder: (context, snapshot) {
                    final username = snapshot.data ?? '';
                    return Text(
                      '@$username',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      backgroundColor: primaryColor,
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Menu Items
            Expanded(
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.verified_outlined,
                    title: 'Verification',
                    hasCheckmark: true,
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.settings_outlined,
                    title: 'Settings',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Change password',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.history,
                    title: 'Order history',
                    onTap: () {},
                  ),
                  _buildMenuItem(
                    icon: Icons.info_outline,
                    title: 'About Us',
                    onTap: () {
                      Get.to(() => const AboutUsScreen());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool hasCheckmark = false,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        leading: Icon(
          icon,
          color: Colors.grey[700],
          size: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasCheckmark)
              Container(
                margin: const EdgeInsets.only(right: 8),
                child: Icon(
                  Icons.check,
                  color: Colors.green[600],
                  size: 20,
                ),
              ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

// Example usage in main.dart
