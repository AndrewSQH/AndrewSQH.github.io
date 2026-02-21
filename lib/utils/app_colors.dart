import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFE76F51);
  static const Color primaryLight = Color(0xFFF4A261);
  static const Color primaryDark = Color(0xFF264653);
  static const Color accent = Color(0xFFE9C46A);
  
  static const Color background = Color(0xFFF8F5F0);
  static const Color backgroundDark = Color(0xFFEDE8E0);
  
  static const Color textPrimary = Color(0xFF264653);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textHint = Color(0xFF999999);
  
  static const Color divider = Color(0xFFE0E0E0);
  static const Color cardBackground = Colors.white;
  
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  
  static const Color sliderActive = primary;
  static const Color sliderInactive = Color(0xFFE0E0E0);
  static const Color sliderThumb = primary;
  
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = primaryLight;
  
  static const Color iconSelected = primary;
  static const Color iconUnselected = Color(0xFF999999);
  
  static const Color border = primary;
  static const Color borderLight = Color(0xFFE0E0E0);
  
  static const Color shadow = Color(0x26000000);
  static const Color shadowLight = Color(0x14000000);
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient warmGradient = LinearGradient(
    colors: [primary, primaryLight, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }
}
