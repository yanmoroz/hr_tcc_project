import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/value_objects/status_group_type.dart';
import '../../domain/domain.dart';

class StatusFilterTabs extends StatelessWidget {
  final List<ApplicationStatistics> statistics;
  final StatusGroupType? selectedStatusGroup;
  final ValueChanged<StatusGroupType?> onStatusGroupChanged;

  const StatusFilterTabs({
    super.key,
    required this.statistics,
    required this.selectedStatusGroup,
    required this.onStatusGroupChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total count
    final totalCount = statistics.fold<int>(0, (sum, stat) => sum + stat.count);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Row(
        children: [
          // "Все статусы" tab
          _buildFilterTab(
            label: 'Все статусы',
            count: totalCount,
            isSelected: selectedStatusGroup == null,
            onTap: () => onStatusGroupChanged(null),
          ),
          // Individual status tabs
          ...statistics.map((stat) {
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _buildFilterTab(
                label: stat.statusGroupName,
                count: stat.count,
                isSelected: selectedStatusGroup == stat.statusGroup,
                onTap: () => onStatusGroupChanged(stat.statusGroup),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterTab({
    required String label,
    required int count,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
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
              label,
              style: AppTypography.textMedium1.copyWith(
                color: isSelected ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(width: 6),
            Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
