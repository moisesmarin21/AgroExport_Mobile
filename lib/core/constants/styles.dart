import 'package:flutter/material.dart';
import 'colors.dart';

class AppStyles {
  static const TextStyle title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    fontFamily: 'Montserrat',
  );

  static const TextStyle titleGreen = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    fontFamily: 'Montserrat',
  );

  static const TextStyle titleGreenBold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
    fontFamily: 'Montserrat',
  );

  static const TextStyle titleWhite = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.background,
    fontFamily: 'Montserrat',
  );

  static const TextStyle titleWhiteBold = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColors.background,
    fontFamily: 'Montserrat',
  );

  static const TextStyle labelGreen = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    fontFamily: 'Montserrat',
  );

  static const TextStyle labelGreenSubrayado = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
    fontFamily: 'Montserrat',
  );

  static const TextStyle labelBlackSubrayado = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.textPrimary,
    fontFamily: 'Montserrat',
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondary,
    fontFamily: 'Montserrat',
  );

  static const TextStyle subtitleBlack = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Montserrat',
  );

  static const TextStyle subtitleGreen = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    fontFamily: 'Montserrat',
  );
  
  static const TextStyle subtitleGreenSubrayado = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.primary,
    fontFamily: 'Montserrat',
  );

  static const TextStyle subtitleWhiteSubrayado = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.background,
    decoration: TextDecoration.underline,
    decorationColor: AppColors.background,
    fontFamily: 'Montserrat',
  );

  static const TextStyle subtitleWhite = TextStyle(
    fontSize: 16,
    color: AppColors.background,
    fontFamily: 'Montserrat',
  );

  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
    color: AppColors.textPrimary,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    fontFamily: 'Montserrat',
    color: Colors.black,
  );

  static const TextStyle labelLargeGreen = TextStyle(
    color: AppColors.primary,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
  );

  static const TextStyle labelBlocked = TextStyle(
    color: AppColors.secondary,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat',
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    fontFamily: 'Montserrat',
  );

  static const TextStyle labelStrong = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat',
  );
  

  static const TextStyle error = TextStyle(
    fontSize: 12,
    color: AppColors.error,
    fontFamily: 'Montserrat',
  );

  // ESTILOS PARA TEXTOS DE FORMULARIOS
  static const TextStyle inputLabel = TextStyle(
    fontSize: 16,
    color: AppColors.primary,
    fontWeight: FontWeight.w400,
    height: 0.1,
    fontFamily: 'Montserrat',
  );

  // ESTILOS PARA TEXTOS DE BOTONES
  static const TextStyle buttonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    decoration: TextDecoration.none,
    fontFamily: 'Montserrat',
  );

  static const TextStyle buttonLargeText = TextStyle(
    color: AppColors.primary,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    fontFamily: 'Montserrat',
  );

  static const TextStyle buttonWhiteText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.background,
    decoration: TextDecoration.none,
    fontFamily: 'Montserrat',
  );

  // ESTILOS PARA HINTTEXT
  static const TextStyle labelHintText = TextStyle(
    color: AppColors.primary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    fontFamily: 'Montserrat',
  );

  static const TextStyle labelHintTextGris = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    fontFamily: 'Montserrat',
  );
}
