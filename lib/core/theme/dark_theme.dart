import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import 'text_styles.dart';

/// ============================================================================
/// Family Finance Manager
/// Dark Theme
/// ============================================================================

class DarkTheme {
  DarkTheme._();

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      //----------------------------------------------------------------------
      // Colors
      //----------------------------------------------------------------------

      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        error: AppColors.error,
        surface: Color(0xFF1E1E1E),
      ),

      scaffoldBackgroundColor: const Color(0xFF121212),

      //----------------------------------------------------------------------
      // Typography
      //----------------------------------------------------------------------

      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge.copyWith(
          color: Colors.white,
        ),
        displayMedium: AppTextStyles.displayMedium.copyWith(
          color: Colors.white,
        ),

        headlineLarge: AppTextStyles.headlineLarge.copyWith(
          color: Colors.white,
        ),
        headlineMedium: AppTextStyles.headlineMedium.copyWith(
          color: Colors.white,
        ),
        headlineSmall: AppTextStyles.headlineSmall.copyWith(
          color: Colors.white,
        ),

        titleLarge: AppTextStyles.titleLarge.copyWith(
          color: Colors.white,
        ),
        titleMedium: AppTextStyles.titleMedium.copyWith(
          color: Colors.white,
        ),
        titleSmall: AppTextStyles.titleSmall.copyWith(
          color: Colors.white,
        ),

        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: Colors.white,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: Colors.white,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: Colors.white70,
        ),

        labelLarge: AppTextStyles.labelLarge.copyWith(
          color: Colors.white,
        ),
        labelMedium: AppTextStyles.labelMedium.copyWith(
          color: Colors.white70,
        ),
        labelSmall: AppTextStyles.labelSmall.copyWith(
          color: Colors.white60,
        ),
      ),

      //----------------------------------------------------------------------
      // AppBar
      //----------------------------------------------------------------------

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),

      //----------------------------------------------------------------------
      // Card
      //----------------------------------------------------------------------

      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E1E),
        elevation: AppConstants.cardElevation,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadius,
          ),
        ),
      ),

      //----------------------------------------------------------------------
      // Elevated Button
      //----------------------------------------------------------------------

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: AppTextStyles.button,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.borderRadius,
            ),
          ),
        ),
      ),

      //----------------------------------------------------------------------
      // Outlined Button
      //----------------------------------------------------------------------

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: const BorderSide(
            color: AppColors.primaryLight,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.borderRadius,
            ),
          ),
        ),
      ),

      //----------------------------------------------------------------------
      // Input Decoration
      //----------------------------------------------------------------------

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadius,
          ),
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadius,
          ),
          borderSide: const BorderSide(
            color: Colors.white24,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.primaryLight,
            width: 2,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppConstants.borderRadius,
          ),
          borderSide: const BorderSide(
            color: AppColors.error,
          ),
        ),
      ),

      //----------------------------------------------------------------------
      // Divider
      //----------------------------------------------------------------------

      dividerTheme: const DividerThemeData(
        color: Colors.white12,
        thickness: 1,
      ),

      //----------------------------------------------------------------------
      // Floating Action Button
      //----------------------------------------------------------------------

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }
}
