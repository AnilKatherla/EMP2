import 'package:flutter/material.dart';

class Responsive {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double horizontalPadding;
  static late double verticalPadding;
  static late bool isMobile;
  static late bool isTablet;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    isMobile = screenWidth < 600;
    isTablet = screenWidth >= 600 && screenWidth < 1200;

    horizontalPadding = screenWidth * 0.05;
    verticalPadding = screenHeight * 0.02;
  }

  // Get proportional height
  static double height(double percentage) {
    return screenHeight * (percentage / 100);
  }

  // Get proportional width
  static double width(double percentage) {
    return screenWidth * (percentage / 100);
  }

  // Vertical Spacing System
  static Widget spacingV8() => const SizedBox(height: 8);
  static Widget spacingV16() => const SizedBox(height: 16);
  static Widget spacingV24() => const SizedBox(height: 24);
  static Widget spacingV32() => const SizedBox(height: 32);
  static Widget spacingV48() => const SizedBox(height: 48);

  // Horizontal Spacing System
  static Widget spacingH8() => const SizedBox(width: 8);
  static Widget spacingH16() => const SizedBox(width: 16);

  // Padding helper
  static EdgeInsets get screenPadding => const EdgeInsets.symmetric(horizontal: 16);
}
