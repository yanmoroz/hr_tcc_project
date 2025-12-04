import 'package:flutter/material.dart';

import '../theme/theme.dart';

const List<Color> _avatarColors = [
  AppColors.blue500,
  AppColors.blue300,
  AppColors.green500,
  AppColors.orange500,
  AppColors.red500,
  AppColors.red300,
  AppColors.yellow500,
];

Color getAvatarColor(String identifier) {
  final hash = identifier.hashCode;
  return _avatarColors[hash.abs() % _avatarColors.length];
}
