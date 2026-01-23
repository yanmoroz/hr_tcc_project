import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PincodeDots extends StatelessWidget {
  final int filledCount;
  final int totalCount;
  final bool hasError;

  const PincodeDots({
    super.key,
    required this.filledCount,
    this.totalCount = 4,
    this.hasError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalCount, (index) {
        final isFilled = index < filledCount;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasError
                ? AppColors.red500
                : isFilled
                    ? AppColors.blue700
                    : AppColors.grey500,
          ),
        );
      }),
    );
  }
}
