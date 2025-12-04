import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../domain/domain.dart';

class PollItemViewModel {
  final Poll poll;
  final Uint8List? coverImage;

  const PollItemViewModel({required this.poll, this.coverImage});

  String? get answersCountText {
    if (poll.countAnswers == 0) {
      return null;
    }
    return '${poll.countAnswers} answers';
  }

  BoxDecoration? get decoration {
    if (!hasCoverImage) {
      return null;
    }

    return BoxDecoration(
      borderRadius: BorderRadius.circular(12.0),
      image: DecorationImage(
        image: MemoryImage(coverImage!),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.mode(
          Colors.black.withAlpha(40),
          BlendMode.darken,
        ),
      ),
    );
  }

  bool get hasCoverImage => coverImage != null;

  bool get shouldShowNewBadge => poll.isNew;

  bool get shouldShowShortDescription => poll.shortDescription.isNotEmpty;

  String get statusText {
    return poll.canAnswer ? 'Can answer' : 'Cannot answer';
  }

  TextStyle? answersCountStyle(TextTheme textTheme, ColorScheme colorScheme) {
    return textTheme.bodySmall?.copyWith(
      color: getSecondaryTextColor(colorScheme),
    );
  }

  Color? getSecondaryTextColor(ColorScheme colorScheme) {
    return hasCoverImage ? Colors.white70 : null;
  }

  Color getStatusColor(ColorScheme colorScheme) {
    if (hasCoverImage) {
      return Colors.white70;
    }
    return poll.canAnswer ? colorScheme.primary : colorScheme.error;
  }

  Color? getTextColor(ColorScheme colorScheme) {
    return hasCoverImage ? Colors.white : null;
  }

  TextStyle? separatorStyle(TextTheme textTheme, ColorScheme colorScheme) {
    return textTheme.bodySmall?.copyWith(
      color: getSecondaryTextColor(colorScheme),
    );
  }

  TextStyle? shortDescriptionStyle(
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return textTheme.bodyMedium?.copyWith(color: getTextColor(colorScheme));
  }

  TextStyle statusStyle(TextTheme textTheme, ColorScheme colorScheme) {
    return textTheme.bodySmall?.copyWith(color: getStatusColor(colorScheme)) ??
        const TextStyle();
  }

  TextStyle? titleStyle(TextTheme textTheme, ColorScheme colorScheme) {
    return textTheme.titleLarge?.copyWith(
      color: getTextColor(colorScheme),
      fontWeight: FontWeight.bold,
    );
  }
}
