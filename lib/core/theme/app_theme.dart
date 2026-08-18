import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_borders.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_spacing.dart';

abstract final class AppTheme {
  static ThemeData get light => _de(
        brightness: Brightness.light,
        paleta: AppColors.clara,
      );

  static ThemeData get dark => _de(
        brightness: Brightness.dark,
        paleta: AppColors.oscura,
      );

  static ThemeData _de({
    required Brightness brightness,
    required PaletaColores paleta,
  }) {
    final oscuro = brightness == Brightness.dark;
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: paleta.primary,
        primary: paleta.primary,
        surface: paleta.surface,
        brightness: brightness,
      ).copyWith(surfaceTint: Colors.transparent),
    );

    return base.copyWith(
      applyElevationOverlayColor: false,
      scaffoldBackgroundColor: paleta.background,
      textTheme: GoogleFonts.montserratTextTheme(base.textTheme).apply(
        bodyColor: paleta.textPrimary,
        displayColor: paleta.textPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: paleta.surface,
        foregroundColor: paleta.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        systemOverlayStyle:
            oscuro ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: paleta.textPrimary,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: paleta.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(
            right: Radius.circular(AppRadius.lg),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: paleta.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
          side: BorderSide(color: paleta.border, width: AppBorders.thin),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: paleta.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: paleta.border, width: AppBorders.thin),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: paleta.border, width: AppBorders.thin),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(
            color: paleta.primary,
            width: AppBorders.strong,
          ),
        ),
        hintStyle: GoogleFonts.montserrat(
          color: paleta.textMuted,
          fontWeight: FontWeight.w500,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: paleta.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 52),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: paleta.textPrimary,
          minimumSize: const Size(48, 52),
          side: BorderSide(
            color: paleta.borderStrong,
            width: AppBorders.thin,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: paleta.border,
        thickness: AppBorders.thin,
        space: AppBorders.thin,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: paleta.surface,
        indicatorColor: oscuro
            ? paleta.primary.withValues(alpha: 0.35)
            : paleta.primaryLight,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: paleta.primary,
        foregroundColor: Colors.white,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return paleta.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return paleta.primary;
          return paleta.borderStrong;
        }),
      ),
    );
  }
}
