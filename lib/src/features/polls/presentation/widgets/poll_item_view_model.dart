import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../domain/entities/entities.dart';

/// View model for [PollItem] widget.
/// Encapsulates presentation logic and computed properties.
class PollItemViewModel {
  final Poll poll;
  final Uint8List? coverImage;

  const PollItemViewModel({required this.poll, this.coverImage});

  /// Whether the item has a cover image
  bool get hasCoverImage => coverImage != null;

  /// Text color based on whether there's a cover image
  Color? getTextColor(ColorScheme colorScheme) {
    return hasCoverImage ? Colors.white : null;
  }

  /// Secondary text color based on whether there's a cover image
  Color? getSecondaryTextColor(ColorScheme colorScheme) {
    return hasCoverImage ? Colors.white70 : null;
  }

  /// Status text color based on cover image and poll state
  Color getStatusColor(ColorScheme colorScheme) {
    if (hasCoverImage) {
      return Colors.white70;
    }
    return poll.canAnswer ? colorScheme.primary : colorScheme.error;
  }

  /// Formatted answers count text
  String? get answersCountText {
    if (poll.countAnswers == 0) {
      return null;
    }
    return '${poll.countAnswers} answers';
  }

  /// Status text for the poll
  String get statusText {
    return poll.canAnswer ? 'Can answer' : 'Cannot answer';
  }

  /// Whether to show the short description
  bool get shouldShowShortDescription => poll.shortDescription.isNotEmpty;

  /// Whether to show the new badge
  bool get shouldShowNewBadge => poll.isNew;

  /// Title style based on theme and cover image
  TextStyle? titleStyle(TextTheme textTheme, ColorScheme colorScheme) {
    return textTheme.titleLarge?.copyWith(color: getTextColor(colorScheme), fontWeight: FontWeight.bold);
  }

  /// Short description style based on theme and cover image
  TextStyle? shortDescriptionStyle(TextTheme textTheme, ColorScheme colorScheme) {
    return textTheme.bodyMedium?.copyWith(color: getTextColor(colorScheme));
  }

  /// Answers count style based on theme and cover image
  TextStyle? answersCountStyle(TextTheme textTheme, ColorScheme colorScheme) {
    return textTheme.bodySmall?.copyWith(color: getSecondaryTextColor(colorScheme));
  }

  /// Separator style based on theme and cover image
  TextStyle? separatorStyle(TextTheme textTheme, ColorScheme colorScheme) {
    return textTheme.bodySmall?.copyWith(color: getSecondaryTextColor(colorScheme));
  }

  /// Status style based on theme and cover image
  TextStyle statusStyle(TextTheme textTheme, ColorScheme colorScheme) {
    return textTheme.bodySmall?.copyWith(color: getStatusColor(colorScheme)) ?? const TextStyle();
  }

  /// Box decoration for the container if cover image exists
  BoxDecoration? get decoration {
    if (!hasCoverImage) {
      return null;
    }

    return BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      image: DecorationImage(
        image: MemoryImage(coverImage!),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(Colors.black.withAlpha(40), BlendMode.darken),
      ),
    );
  }
}
