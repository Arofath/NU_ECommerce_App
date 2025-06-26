import 'package:flutter/material.dart';

String getImageUrl(String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) {
    return '';
  }
  return 'http://10.0.2.2:8000$imagePath';
}

Color parseColorName(String colorName) {
  switch (colorName.toLowerCase()) {
    case 'red':
      return Colors.red;
    case 'blue':
      return Colors.blue;
    case 'black':
      return Colors.black;
    case 'white':
      return Colors.white;
    case 'green':
      return Colors.green;
    case 'yellow':
      return Colors.yellow;
    case 'orange':
      return Colors.orange;
    case 'grey':
    case 'gray':
      return Colors.grey;
    // add more colors if you need
    default:
      return Colors.grey; // fallback color if unknown
  }
}
