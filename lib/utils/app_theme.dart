import 'package:flutter/material.dart';

class AppTheme {
  // Define Colors
  static const Color primaryColor = Color(0xFFF0EFEF);
  static const Color secondaryColor = Color(0xFF5D6826);
  static const Color backgroundColor = Color(0xFFF1F8E9);
  static const Color buttonColor = Color(0xFF5B8D2F);
  static const Color textColor = Color(0xFF212121);
  static const Color errorColor = Color(0xFFF44336);

  // Define Text Styles
  static TextStyle headingTextStyle = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static TextStyle subHeadingTextStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static TextStyle bodyTextStyle = const TextStyle(
    fontSize: 16,
    color: textColor,
  );

  static TextStyle captionTextStyle = const TextStyle(
    fontSize: 14,
    color: textColor,
  );

  static TextStyle buttonTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}
