import 'package:flutter/material.dart';

/// Predefined avatar colors for consistent user identification.
const List<Color> _avatarColors = [
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.pink,
  Colors.indigo,
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
