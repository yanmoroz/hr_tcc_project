import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // "Все статусы" tab
          _buildFilterTab(
            label: 'Все статусы',
            count: totalCount,
            isSelected: selectedStatusGroup == null,
            onTap: () => onStatusGroupChanged(null),
          ),
          const SizedBox(width: 8),

          // Individual status tabs
          ...statistics.map((stat) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2196F3) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF212121),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.3)
                    : const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count >= 100 ? '99+' : count.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : const Color(0xFF757575),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
