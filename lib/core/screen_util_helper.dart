import 'package:flutter/material.dart';
import 'dart:math'; // ✅ Required for scaleAll

class ScreenUtilHelper {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockWidth;
  static late double blockHeight;

  static const double baseWidth = 375.0;  // your design width
  static const double baseHeight = 812.0; // your design height

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;
  }

  static double scaleWidth(double width) {
    return (width / baseWidth) * screenWidth;
  }

  static double scaleHeight(double height) {
    return (height / baseHeight) * screenHeight;
  }

  static double scaleText(double fontSize) {
    return scaleWidth(fontSize); // You may also choose scaleHeight if needed
  }

  static double scaleRadius(double radius) {
    return scaleWidth(radius);
  }

  // ✅ Shortcuts
  static double width(double value) => scaleWidth(value);
  static double height(double value) => scaleHeight(value);
  static double fontSize(double value) => scaleText(value);
  static double radius(double value) => scaleRadius(value);

  // ✅ Utility for consistent scaling
  static double scaleAll(double value) {
    return min(scaleWidth(value), scaleHeight(value));
  }
}
