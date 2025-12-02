import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTypography {
  static TextStyle get _base =>
      TextStyle(fontWeight: FontWeight.normal, color: AppColors.black);

  static TextStyle get numbersMedium0 => _base.copyWith(
    fontSize: 44,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 48 / 44,
  );

  static TextStyle get numbersMedium1 => _base.copyWith(
    fontSize: 40,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 44 / 40,
  );

  static TextStyle get numbersRegular2 => _base.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 44 / 36,
  );

  static TextStyle get numbersMedium2 => _base.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 44 / 36,
  );

  static TextStyle get titleSemibold0 => _base.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 34 / 32,
  );

  static TextStyle get titleBold1 => _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    height: 32 / 28,
  );

  static TextStyle get titleMedium2 => _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 28 / 24,
  );

  static TextStyle get titleBold2 => _base.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    height: 28 / 24,
  );

  static TextStyle get titleSemibold3 => _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 24 / 20,
  );

  static TextStyle get titleBold3 => _base.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    height: 24 / 20,
  );

  static TextStyle get titleSemibold4 => _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 22 / 18,
  );

  static TextStyle get titleBold4 => _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
    height: 22 / 18,
  );

  static TextStyle get textRegular1 => _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 20 / 16,
  );

  static TextStyle get textMedium1 => _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 20 / 16,
  );

  static TextStyle get textSemibold1 => _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 20 / 16,
  );

  static TextStyle get textRegular2 => _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 18 / 14,
  );

  static TextStyle get textLink2 => _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.3,
    height: 18 / 14,
  );

  static TextStyle get textMedium2 => _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 18 / 14,
  );

  static TextStyle get textSemibold2 => _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 18 / 14,
  );

  static TextStyle get buttonMedium1 => _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 20 / 16,
  );

  static TextStyle get captionSemibold1 => _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.7,
    height: 20 / 13,
  );

  static TextStyle get captionMedium2 => _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 14 / 12,
  );

  static TextStyle get captionMedium3 => _base.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 12 / 10,
  );

  static TextStyle get captionMedium4 => _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    height: 12 / 11,
  );

  static TextStyle get captionSemibold3 => _base.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 12 / 10,
  );
}
