import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import 'filter_item.dart';

class FiltersBar<T> extends StatelessWidget {
  final List<FilterItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T?> onFilterChanged;
  final EdgeInsets padding;

  const FiltersBar({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onFilterChanged,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: padding,
        child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            _FilterTab<T>(
              item: items[i],
              isSelected: selectedValue == items[i].value,
              onTap: () => onFilterChanged(items[i].value),
            ),
          ],
        ],
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;

  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      child: Text(
        count >= 100 ? '99+' : count.toString(),
        style: AppTypography.captionSemibold3.black,
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _FilterTab<T> extends StatelessWidget {
  final FilterItem<T> item;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterTab({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue700 : AppColors.grey100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.label,
              style: AppTypography.textMedium1.copyWith(
                color: isSelected ? AppColors.white : AppColors.black,
              ),
            ),
            if (item.count != null) ...[
              const SizedBox(width: 6),
              _CountBadge(count: item.count!),
            ],
          ],
        ),
      ),
    );
  }
}
