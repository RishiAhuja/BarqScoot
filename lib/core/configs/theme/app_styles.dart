import 'package:flutter/material.dart';

class AppStyles {
  static const double borderRadius = 16.0;
  static const double spacing = 16.0;
  static const double iconSize = 24.0;

  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(borderRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );
}
