import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract final class AppTextStyles {
  static TextStyle get _base => GoogleFonts.montserrat(
        color: AppColors.textPrimary,
      );

  static TextStyle get _mono => GoogleFonts.robotoMono(
        color: AppColors.textPrimary,
      );

  static TextStyle display = _base.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static TextStyle h1 = _base.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static TextStyle h2 = _base.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static TextStyle h3 = _base.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  static TextStyle body = _base.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static TextStyle bodySmall = _base.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static TextStyle label = _base.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static TextStyle button = _base.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 0.2,
  );

  static TextStyle caption = _base.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static TextStyle money = _mono.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle moneyLg = _mono.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static TextStyle moneyXl = _mono.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.15,
  );

  static TextStyle receipt = _mono.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.35,
    color: AppColors.receiptLine,
  );
}
