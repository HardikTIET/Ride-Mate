import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_style.dart';

class AppTheme {
  AppTheme._();

  static ThemeData data(bool isDark) {
    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: isDark ? Colors.black : Colors.teal,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Colors.black : Colors.teal,
        centerTitle: true,
        titleTextStyle: AppFont.bold.copyWith(color: Colors.white,fontSize: 18),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isDark ? Colors.black : Colors.teal,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 2.h,
        extendedTextStyle: AppFont.normal.s14,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? Colors.black : Colors.teal,
          foregroundColor: Colors.white,
          textStyle: AppFont.normal.s14.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: isDark ? Colors.black : Colors.teal,)
          ),
          foregroundColor: isDark ? Colors.black : Colors.teal,
          textStyle: AppFont.normal.s14.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      fontFamily: GoogleFonts.poppins().fontFamily,
      textTheme: TextTheme(
        bodySmall: AppFont.normal.s12.copyWith(color: Colors.black),
        bodyMedium: AppFont.normal.s14.copyWith(color: Colors.black),
        bodyLarge: AppFont.normal.s20.copyWith(color: Colors.black),
        displayMedium: AppFont.normal.s14
            .copyWith(color: isDark ? Colors.white : Colors.black),
      ),
    );
  }
}
