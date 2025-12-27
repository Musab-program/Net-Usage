import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_color.dart';

/// Provides the application's light and dark themes.
class AppThemes {
  /// The light theme configuration.
  static final ThemeData light = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkPrimaryColor,
      brightness: Brightness.light,
      primary: AppColors.darkPrimaryColor,
      onPrimary: AppColors.textIcons,
      secondary: AppColors.accentColor,
      onSecondary: AppColors.textIcons,
      surface: AppColors.textIcons,
      onSurface: AppColors.primaryText,
    ),
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
    cardColor: AppColors.textIcons,
    fontFamily: 'Cairo',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkPrimaryColor,
      foregroundColor: AppColors.textIcons,
      actionsIconTheme: IconThemeData(color: AppColors.textIcons),
      centerTitle: true,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.primaryText),
      bodyMedium: TextStyle(color: AppColors.primaryText),
      bodySmall: TextStyle(color: AppColors.secondaryText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.primaryColor),
        foregroundColor: WidgetStateProperty.all(AppColors.textIcons),
        overlayColor: WidgetStateProperty.all(AppColors.darkPrimaryColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: AppColors.dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: AppColors.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: AppColors.darkPrimaryColor, width: 2.0),
      ),
      fillColor: AppColors.textIcons,
      filled: true,
      hintStyle: TextStyle(color: AppColors.secondaryText),
    ),
  );

  /// The dark theme configuration.
  static final ThemeData dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.darkPrimaryColor,
      brightness: Brightness.dark,
      primary: AppColors.darkPrimaryColor,
      onPrimary: AppColors.primaryText,
      secondary: AppColors.accentColor,
      onSecondary: AppColors.primaryText,
      surface: AppColors.secondaryText,
      onSurface: AppColors.textIcons,
    ),
    scaffoldBackgroundColor: AppColors.primaryText,
    cardColor: AppColors.secondaryText,
    fontFamily: 'Cairo',
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkPrimaryColor,
      foregroundColor: AppColors.textIcons,
      actionsIconTheme: IconThemeData(color: AppColors.textIcons),
      centerTitle: true,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textIcons),
      bodyMedium: TextStyle(color: AppColors.textIcons),
      bodySmall: TextStyle(color: AppColors.secondaryText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(AppColors.darkPrimaryColor),
        foregroundColor: WidgetStateProperty.all(AppColors.textIcons),
        overlayColor: WidgetStateProperty.all(AppColors.lightPrimaryColor),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: AppColors.secondaryText),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: AppColors.secondaryText),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(color: AppColors.darkPrimaryColor, width: 2.0),
      ),
      fillColor: AppColors.primaryText,
      filled: true,
      hintStyle: TextStyle(color: AppColors.secondaryText),
    ),
  );
}
