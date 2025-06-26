import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Introduction Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[50]!, Colors.blue[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shopping_bag,
                          color: Colors.blue[700], size: 28),
                      const SizedBox(width: 10),
                      Text(
                        'Our E-Commerce App',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to our comprehensive e-commerce platform! Our app specializes in selling fashionable shoes, stylish bags, and trendy shirts. We provide a seamless shopping experience with a user-friendly interface, secure payment options, and fast delivery services.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildFeatureChip('👟 Shoes'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('🎒 Bags'),
                      const SizedBox(width: 8),
                      _buildFeatureChip('👕 Shirts'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Team Section Header
            Text(
              'Meet Our Development Team',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Software Development Students from Class ES2',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 24),

            // Team Members
            _buildTeamMember(
              name: 'Alex Johnson',
              id: 'ES2001',
              role: 'Lead Developer & UI/UX Designer',
              description:
                  'Specializes in Flutter development and user interface design. Passionate about creating intuitive and beautiful mobile applications.',
              avatar: '🧑‍💻',
              color: Colors.blue,
            ),

            const SizedBox(height: 16),

            _buildTeamMember(
              name: 'Sarah Chen',
              id: 'ES2002',
              role: 'Backend Developer & Database Engineer',
              description:
                  'Expert in server-side development and database management. Ensures our app runs smoothly with secure and efficient backend systems.',
              avatar: '👩‍💻',
              color: Colors.green,
            ),

            const SizedBox(height: 16),

            _buildTeamMember(
              name: 'Michael Rodriguez',
              id: 'ES2003',
              role: 'Quality Assurance & Testing Specialist',
              description:
                  'Focuses on testing and quality assurance to deliver bug-free applications. Ensures optimal performance across all devices.',
              avatar: '👨‍🔬',
              color: Colors.orange,
            ),

            const SizedBox(height: 32),

            // Contact Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Have questions or feedback? We\'d love to hear from you! Reach out to our development team for any inquiries about our e-commerce platform.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String id,
    required String role,
    required String description,
    required String avatar,
    required MaterialColor color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color[100],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: color[300]!, width: 2),
            ),
            child: Center(
              child: Text(
                avatar,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Member Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color[200]!),
                  ),
                  child: Text(
                    'ID: $id',
                    style: TextStyle(
                      fontSize: 12,
                      color: color[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color[600],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: Colors.blue[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
