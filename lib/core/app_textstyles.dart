import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const headline6 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static const bodyText2 = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  static const buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const titleLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Color(0xFF333333),
  );

  static const chatTextWhite = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static const chatTextBlack = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

  static TextStyle timestamp(bool isMe) => TextStyle(
    fontSize: 11,
    color: isMe ? Colors.white70 : Colors.black54,
  );

  static const TextStyle listTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.black87,
  );

  static const TextStyle avatarInitial = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Color(0xFF6A11CB), // same as primary
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );
}
