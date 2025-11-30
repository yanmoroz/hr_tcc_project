import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Predefined avatar colors for consistent user identification.
const List<Color> _avatarColors = [
  AppColors.blue500,
  AppColors.blue300,
  AppColors.green500,
  AppColors.orange500,
  AppColors.red500,
  AppColors.red300,
  AppColors.yellow500,
];

/// Returns a consistent color based on the provided identifier.
///
/// Uses the hash code of [identifier] to deterministically select
/// a color from the predefined palette. The same identifier will
/// always return the same color.
Color getAvatarColor(String identifier) {
  final hash = identifier.hashCode;
  return _avatarColors[hash.abs() % _avatarColors.length];
}
