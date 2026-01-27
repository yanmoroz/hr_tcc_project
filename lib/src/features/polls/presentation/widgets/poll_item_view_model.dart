import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/theme.dart';
import '../../domain/domain.dart';

class PollItemViewModel {
  final Poll poll;
  final Uint8List? coverImage;

  const PollItemViewModel({required this.poll, this.coverImage});

  String get answersCountText {
    return 'Прошли: ${poll.countAnswers}';
  }

  bool get hasCoverImage => coverImage != null;

  bool get isActivePoll => poll.canAnswer && !hasCoverImage;

  bool get shouldShowActionButton => poll.canAnswer;

  bool get shouldShowShortDescription => poll.shortDescription.isNotEmpty;

  String get statusText {
    return poll.canAnswer ? 'Не пройден' : 'Пройден';
  }

  String get timeText {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final pollDate = DateTime(
      poll.createdAt.year,
      poll.createdAt.month,
      poll.createdAt.day,
    );

    final timeFormat = DateFormat('HH:mm').format(poll.createdAt);

    if (pollDate == today) {
      return 'Сегодня в $timeFormat';
    } else if (pollDate == yesterday) {
      return 'Вчера в $timeFormat';
    } else {
      final dateFormat = DateFormat('dd.MM.yyyy').format(poll.createdAt);
      return '$dateFormat в $timeFormat';
    }
  }

  Color get cardBackgroundColor {
    if (isActivePoll) {
      return AppColors.blue700;
    }
    return AppColors.white;
  }

  Color get statusChipBackgroundColor {
    if (poll.canAnswer) {
      return AppColors.orange100;
    }
    return AppColors.grey500;
  }

  Color get statusChipTextColor {
    if (poll.canAnswer) {
      return AppColors.black;
    }
    return AppColors.white;
  }

  Color get textColor {
    if (isActivePoll) {
      return AppColors.white;
    }
    return AppColors.black;
  }

  Color get secondaryTextColor {
    if (isActivePoll) {
      return AppColors.white.withValues(alpha: 0.7);
    }
    return AppColors.grey700;
  }
}
