import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF1976D2);
  static const Color accent = Color(0xFF2196F3);
  static const Color background = Color(0xFFF5F5F5);
  static const Color white = Colors.white;
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textGrey = Color(0xFF757575);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color starColor = Color(0xFFFFC107);
  static const Color deleteRed = Color(0xFFE53935);
  static const Color freeGreen = Color(0xFF43A047);
  static const Color cardBorder = Color(0xFFE0E0E0);
  static const Color cartHighlight = Color(0xFFE3F2FD);
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const TextStyle productTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
    height: 1.3,
  );

  static const TextStyle price = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    color: AppColors.textGrey,
  );

  static const TextStyle cartItemTitle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle cartItemSub = TextStyle(
    fontSize: 12,
    color: AppColors.textGrey,
  );

  static const TextStyle cartPrice = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textDark,
  );
}
