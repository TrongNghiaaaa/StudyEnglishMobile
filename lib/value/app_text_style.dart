import 'package:flutter/material.dart';

/// Typo tokens & styles dùng chung toàn app
class AppTextStyle {
  AppTextStyle._();

  // --- Tokens (dễ đổi 1 chỗ) ---
  static const String family = 'Poppins';

  // baseline line-height
  static const double _lhTight = 1.2;
  static const double _lhSnug = 1.25;
  static const double _lhNorm = 1.4;
  static const double _lhRelax = 1.5;

  // --- Semantic styles ---
  // Display / hero
  static const TextStyle display = TextStyle(
    fontFamily: family,
    fontWeight: FontWeight.w700, // Bold
    fontSize: 32,
    height: _lhTight,
    // letterSpacing hơi âm cho tiêu đề lớn thường đẹp hơn,
    // có thể chỉnh thêm nếu bạn muốn.
  );

  // Headline
  static const TextStyle headline = TextStyle(
    fontFamily: family,
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 24,
    height: _lhSnug,
  );

  // Title (section titles)
  static const TextStyle title = TextStyle(
    fontFamily: family,
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 18,
    height: _lhNorm,
  );

  // Body
  static const TextStyle body = TextStyle(
    fontFamily: family,
    fontWeight: FontWeight.w400, // Regular
    fontSize: 14,
    height: _lhRelax,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: family,
    fontWeight: FontWeight.w500, // Medium
    fontSize: 14,
    height: _lhNorm,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: family,
    fontWeight: FontWeight.w300, // Light
    fontSize: 12,
    height: _lhNorm,
  );

  // Label / Button
  static const TextStyle label = TextStyle(
    fontFamily: family,
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 12,
    letterSpacing: 0.3,
    height: 1.2,
  );

  // Caption / helper
  static const TextStyle caption = TextStyle(
    fontFamily: family,
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: _lhNorm,
    letterSpacing: 0.2,
  );

  /// Map sang Material 3 TextTheme để đồng bộ với Theme
  static const TextTheme textTheme = TextTheme(
    displayLarge: display, // hero lớn
    headlineMedium: headline, // header trang/section
    titleLarge: title, // title block/card
    bodyLarge: body, // nội dung chính
    bodyMedium: bodyMedium, // nhấn mạnh nhẹ
    bodySmall: bodySmall, // chú thích nhỏ
    labelLarge: label, // nút/label
  );

  /// Cho phép scale toàn cỡ chữ (ví dụ tăng 10% cho màn hình lớn)
  static TextTheme scaled(double factor) =>
      textTheme.apply(fontSizeFactor: factor);

  /// Helper tạo TextStyle nhanh nhưng vẫn đúng family
  static TextStyle custom({
    double size = 14,
    FontWeight weight = FontWeight.w400,
    double? height,
    double? letterSpacing,
    Color? color,
    FontStyle? fontStyle,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: family,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
      fontStyle: fontStyle,
      decoration: decoration,
    );
  }
}
