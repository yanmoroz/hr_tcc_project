import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

extension TextColorX on TextStyle {
  TextStyle get white => copyWith(color: AppColors.white);
  TextStyle get black => copyWith(color: AppColors.black);
  TextStyle get grey200 => copyWith(color: AppColors.grey200);
  TextStyle get grey500 => copyWith(color: AppColors.grey500);
  TextStyle get grey700 => copyWith(color: AppColors.grey700);
  TextStyle get grey100 => copyWith(color: AppColors.grey100);
  TextStyle get grey50 => copyWith(color: AppColors.grey50);
  TextStyle get blue700 => copyWith(color: AppColors.blue700);
  TextStyle get blue500 => copyWith(color: AppColors.blue500);
  TextStyle get blue300 => copyWith(color: AppColors.blue300);
  TextStyle get blue200 => copyWith(color: AppColors.blue200);
  TextStyle get blue100 => copyWith(color: AppColors.blue100);
  TextStyle get red500 => copyWith(color: AppColors.red500);
  TextStyle get red300 => copyWith(color: AppColors.red300);
  TextStyle get red200 => copyWith(color: AppColors.red200);
  TextStyle get red100 => copyWith(color: AppColors.red100);
  TextStyle get orange500 => copyWith(color: AppColors.orange500);
  TextStyle get orange300 => copyWith(color: AppColors.orange300);
  TextStyle get orange100 => copyWith(color: AppColors.orange100);
  TextStyle get yellow500 => copyWith(color: AppColors.yellow500);
  TextStyle get yellow300 => copyWith(color: AppColors.yellow300);
  TextStyle get yellow100 => copyWith(color: AppColors.yellow100);
  TextStyle get green500 => copyWith(color: AppColors.green500);
  TextStyle get green300 => copyWith(color: AppColors.green300);
}
