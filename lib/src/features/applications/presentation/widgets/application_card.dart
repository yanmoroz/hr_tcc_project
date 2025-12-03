import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/theme.dart';
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
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon based on application form
              Container(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: Center(child: _getApplicationIcon()),
                ),
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
                      style: AppTypography.textSemibold2.black,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Date
                    Text(
                      'от ${DateFormat('dd.MM.yyyy').format(application.applicationDate)}',
                      style: AppTypography.captionMedium2.grey700,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Status badge
              Center(child: _buildStatusBadge()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getApplicationIcon() {
    switch (application.applicationForm.code) {
      case 'absence':
        return SvgPicture.asset(Assets.icons.absenceIcon);
      case 'alpinaAccess':
        return SvgPicture.asset(Assets.icons.alpinaDigitalIcon);
      case 'businessTrip':
        return SvgPicture.asset(Assets.icons.planeIcon);
      case 'courierDelivery':
        return SvgPicture.asset(Assets.icons.deliveryIcon);
      case 'parking':
        return SvgPicture.asset(Assets.icons.carIcon);
      case 'pass':
        return SvgPicture.asset(Assets.icons.passIcon);
      case 'referralProgram':
        return SvgPicture.asset(Assets.icons.referralIcon);
      case 'taxCertificate':
        return SvgPicture.asset(Assets.icons.ndflIcon);
      case 'unplannedTraining':
        return SvgPicture.asset(Assets.icons.educationIcon);
      case 'violation':
        return SvgPicture.asset(Assets.icons.warningIcon);
      case 'workBookCopy':
        return SvgPicture.asset(Assets.icons.document1Icon);
      case 'workCertificate':
        return SvgPicture.asset(Assets.icons.document2Icon);
      default:
        return SvgPicture.asset(
          Assets.icons.commentsIcon,
          colorFilter: const ColorFilter.mode(
            AppColors.grey700,
            BlendMode.srcIn,
          ),
        );
    }
  }

  Widget _buildStatusBadge() {
    final status = application.systemStatus;
    final statusColor = _getStatusColor(status.statusGroup);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(status.name, style: AppTypography.captionMedium2.white),
    );
  }

  Color _getStatusColor(StatusGroupType statusGroup) {
    switch (statusGroup) {
      case StatusGroupType.active:
        return AppColors.blue300;
      case StatusGroupType.agreement:
        return AppColors.green500;
      case StatusGroupType.completed:
        return AppColors.grey700;
      case StatusGroupType.rejected:
        return AppColors.red500;
      case StatusGroupType.canceled:
        return AppColors.grey200;
    }
  }
}
