import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/value_objects/status_group_type.dart';
import '../../domain/domain.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationInfo application;
  final VoidCallback onTap;

  const ApplicationCard({
    super.key,
    required this.application,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        elevation: 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 1),
            ),
            child: Row(
              children: [
                // Icon based on application form
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(child: _getApplicationIcon()),
                ),
                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Application name
                      Text(
                        application.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF212121),
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Date
                      Text(
                        'от ${DateFormat('dd.MM.yyyy').format(application.applicationDate)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Status badge
                _buildStatusBadge(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getApplicationIcon() {
    // Default icon - you can customize based on applicationForm if needed
    return SvgPicture.asset(
      Assets.icons.commentsIcon,
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(Color(0xFF757575), BlendMode.srcIn),
    );
  }

  Widget _buildStatusBadge() {
    final status = application.systemStatus;
    final statusColor = _getStatusColor(status.statusGroup);
    final backgroundColor = statusColor.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.name,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: statusColor,
        ),
      ),
    );
  }

  Color _getStatusColor(StatusGroupType statusGroup) {
    switch (statusGroup) {
      case StatusGroupType.active:
        return const Color(0xFF2196F3); // Blue
      case StatusGroupType.agreement:
        return const Color(0xFF4CAF50); // Green
      case StatusGroupType.completed:
        return const Color(0xFF757575); // Gray
      case StatusGroupType.rejected:
        return const Color(0xFFF44336); // Red
      case StatusGroupType.canceled:
        return const Color(0xFF9E9E9E); // Gray
    }
  }
}
