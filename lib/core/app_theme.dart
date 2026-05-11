import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF0B6B57);
  static const Color primaryDark = Color(0xFF064638);
  static const Color primaryDeep = Color(0xFF04382D);
  static const Color accentGold = Color(0xFFD8B26A);
  static const Color secondary = accentGold;
  static const Color background = Color(0xFFF8F5EF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color text = Color(0xFF1D2B28);
  static const Color muted = Color(0xFF6B7280);
  static const Color border = Color(0xFFEAE6DE);
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDeep, primary],
  );
}

class AppRadius {
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 18;
  static const double xl = 22;
  static const double pill = 50;
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    brightness: Brightness.light,
  ).copyWith(
    primary: AppColors.primary,
    secondary: AppColors.accentGold,
    surface: AppColors.surface,
    onSurface: AppColors.text,
  );

  const baseText = TextStyle(color: AppColors.text, height: 1.35);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: 'Tajawal',
    textTheme: const TextTheme(
      displaySmall: TextStyle(color: AppColors.text, fontWeight: FontWeight.w800),
      headlineSmall: TextStyle(color: AppColors.text, fontWeight: FontWeight.w800),
      titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.w800, fontSize: 20),
      titleMedium: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 16),
      titleSmall: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700, fontSize: 14),
      bodyLarge: TextStyle(color: AppColors.text, fontSize: 15),
      bodyMedium: TextStyle(color: AppColors.text, fontSize: 14),
      bodySmall: TextStyle(color: AppColors.muted, fontSize: 12.5),
      labelLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.w700),
    ).apply(bodyColor: AppColors.text, displayColor: AppColors.text),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 18,
      ),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.border, width: 0.6),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFFBF8F2),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: AppColors.muted),
      labelStyle: baseText.copyWith(color: AppColors.muted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
      prefixIconColor: AppColors.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
        side: const BorderSide(color: AppColors.primary, width: 1.2),
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      selectedColor: AppColors.primary.withValues(alpha: .12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      labelStyle: const TextStyle(color: AppColors.text, fontWeight: FontWeight.w600),
      side: const BorderSide(color: AppColors.border),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    ),
    dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 0.7, space: 0),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: AppColors.primary.withValues(alpha: .12),
      surfaceTintColor: Colors.transparent,
      height: 70,
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 11.5,
          fontWeight: states.contains(WidgetState.selected) ? FontWeight.w800 : FontWeight.w600,
          color: states.contains(WidgetState.selected) ? AppColors.primary : AppColors.muted,
        ),
      ),
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected) ? AppColors.primary : AppColors.muted,
          size: 24,
        ),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primary,
      linearTrackColor: Color(0xFFEFE6D5),
      circularTrackColor: Color(0xFFEFE6D5),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: AppColors.primary,
      dense: false,
      contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    ),
  );
}
