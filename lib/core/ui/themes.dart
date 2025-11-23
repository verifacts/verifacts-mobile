import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:verifacts/core/ui/colors.dart';


ThemeData themeData = FlexThemeData.dark(
  fontFamily: "PlusJakartaSans",
  useMaterial3: true,
  scheme: FlexScheme.aquaBlue,
  appBarStyle: FlexAppBarStyle.scaffoldBackground,
  visualDensity: VisualDensity.compact,
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  scaffoldBackground: AppColors.background,
  surfaceTint: Colors.transparent,
  appBarElevation: 1.0,
);

class AppTextStyles {
  static TextStyle get bold => TextStyle(
    fontFamily: "PlusJakartaSans",
    color: Colors.white,
    fontWeight: FontWeight.w700,
    height: 1.5,
    letterSpacing: -0.03,
  );

  static TextStyle get semiBold => TextStyle(
    fontFamily: "PlusJakartaSans",
    color: Colors.white,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: -0.02,
  );

  static TextStyle get medium => TextStyle(
    fontFamily: "PlusJakartaSans",
    color: AppColors.grey,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: -0.02,
  );

  static TextStyle get regular => TextStyle(
    fontFamily: "PlusJakartaSans",
    color: AppColors.grey,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: -0.02,
  );
}



