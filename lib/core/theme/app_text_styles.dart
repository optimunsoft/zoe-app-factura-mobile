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

  static TextStyle get display => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get h1 => _base.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
      );

  static TextStyle get h2 => _base.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static TextStyle get h3 => _base.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.35,
      );

  static TextStyle get body => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
      );

  static TextStyle get bodySmall => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textSecondary,
      );

  static TextStyle get label => _base.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.3,
      );

  static TextStyle get button => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0.2,
      );

  static TextStyle get caption => _base.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      );

  static TextStyle get money => _mono.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  static TextStyle get moneyLg => _mono.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get moneyXl => _mono.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.15,
      );

  static TextStyle get receipt => _mono.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.35,
        color: AppColors.receiptLine,
      );
}
