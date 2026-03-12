import 'package:flutter/material.dart';
import 'package:hr_tcc_project/src/core/theme/app_colors.dart';

import '../../../../core/entities/application_form.dart';
import '../../../../core/entities/application_form_group.dart';

class ApplicationFormFilterTabs extends StatelessWidget {
  final List<ApplicationFormGroup> groups;
  final List<ApplicationForm> allForms;
  final String? selectedGroupId;
  final ValueChanged<String?> onGroupChanged;

  const ApplicationFormFilterTabs({
    super.key,
    required this.groups,
    required this.allForms,
    required this.selectedGroupId,
    required this.onGroupChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate count per group
    final Map<String, int> groupCounts = {};
    for (final form in allForms) {
      groupCounts[form.idGroup] = (groupCounts[form.idGroup] ?? 0) + 1;
    }

    final totalCount = allForms.length;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // "Все" tab
          _buildFilterTab(
            label: 'Все',
            count: totalCount,
            isSelected: selectedGroupId == null,
            onTap: () => onGroupChanged(null),
          ),
          const SizedBox(width: 8),

          // Individual group tabs
          ...groups.map((group) {
            final count = groupCounts[group.id] ?? 0;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildFilterTab(
                label: group.name,
                count: count,
                isSelected: selectedGroupId == group.id,
                onTap: () => onGroupChanged(group.id),
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
          color: isSelected ? AppColors.blue700 : AppColors.grey100,
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
                color: isSelected ? AppColors.white : AppColors.black,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count >= 100 ? '99+' : count.toString(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
