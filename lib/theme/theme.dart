import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData theme = ThemeData();

final TextTheme textTheme = theme.textTheme.copyWith(
  bodySmall: GoogleFonts.inter(fontSize: 12),
  bodyMedium: GoogleFonts.inter(fontSize: 14),
  bodyLarge: GoogleFonts.inter(fontSize: 18),
  labelSmall: GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.bold,
  ),
  labelMedium: GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  labelLarge: GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  titleLarge: GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
  titleMedium: GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
);

final ThemeData lightModeTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorSchemeSeed: AppColors.yellow,
  textTheme: textTheme,
  appBarTheme: theme.appBarTheme.copyWith(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarColor: AppColors.purple,
      statusBarIconBrightness: Brightness.light,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.yellow,
      foregroundColor: AppColors.titles,
      textStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
  ),
);
