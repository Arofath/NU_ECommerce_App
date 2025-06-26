import 'package:flutter/material.dart';

class RecommendProductBanner extends StatelessWidget {
  const RecommendProductBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image with rounded corners
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            "images/banner.png",
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200, // Set a fixed height
          ),
        ),

        // Overlayed text
        Positioned(
          left: 16,
          bottom: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Recommended Product",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.6),
                      offset: const Offset(0, 2),
                      blurRadius: 6,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "We recommended the best for you.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(0, 1),
                      blurRadius: 4,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
