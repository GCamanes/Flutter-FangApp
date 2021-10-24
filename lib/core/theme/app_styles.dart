import 'dart:ui';

import 'package:fangapp/core/data/app_constants.dart';
import 'package:fangapp/core/utils/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppStyles {
  static double normalizeSize(double size) {
    return size * (AppHelper().deviceSize.width / AppConstants.uiModelWidth);
  }

  static TextStyle mediumTitle({
    double size = 13,
    Color color = AppColors.black90,
    TextDecoration textDecoration = TextDecoration.none,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        fontStyle: fontStyle,
        color: color,
        fontSize: normalizeSize(size),
        fontWeight: FontWeight.w500,
        decoration: textDecoration,
      ),
    );
  }

  static TextStyle highTitle({
    double size = 18,
    Color color = AppColors.black90,
    TextDecoration textDecoration = TextDecoration.none,
    FontStyle fontStyle = FontStyle.normal,
  }) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        fontStyle: fontStyle,
        color: color,
        fontSize: normalizeSize(size),
        fontWeight: FontWeight.w600,
        decoration: textDecoration,
      ),
    );
  }

  static TextStyle regularText({
    double size = 10,
    Color color = AppColors.black90,
    TextDecoration textDecoration = TextDecoration.none,
    FontStyle fontStyle = FontStyle.normal,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    return GoogleFonts.poppins(
      textStyle: TextStyle(
        fontStyle: fontStyle,
        color: color,
        fontSize: normalizeSize(size),
        fontWeight: fontWeight,
        decoration: textDecoration,
      ),
    );
  }
}
