import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../gen/assets.gen.dart';
import '../../features/g2g/notifications/notifications.dart';
import '../../features/g2g/users/domain/domain.dart';
import '../base_types/loading_status.dart';
import '../blocs/current_user/bloc.dart';
import '../theme/theme.dart';
import '../utils/color_utils.dart';
import '../utils/string_utils.dart';

class UserInfoBar extends StatelessWidget {
  final bool enableCorners;
  final bool showShadow;

  const UserInfoBar({
    super.key,
    this.enableCorners = true,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserBloc, CurrentUserState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(enableCorners ? 16 : 0),
              bottomRight: Radius.circular(enableCorners ? 16 : 0),
            ),
            boxShadow: showShadow
                ? [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              4,
              16,
              4 + (enableCorners ? 8 : 0),
            ),
            child: switch (state.status) {
              LoadingStatus.initial => _buildLoadingState(),
              LoadingStatus.loading => _buildLoadingState(),
              LoadingStatus.error => _buildErrorState(context),
              LoadingStatus.success =>
                state.user != null
                    ? _buildLoadedState(state.user!)
                    : _buildErrorState(context),
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Row(
      children: [
        // Shimmer effect placeholder
        Shimmer.fromColors(
          baseColor: AppColors.grey200,
          highlightColor: AppColors.grey100,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.grey200,
                highlightColor: AppColors.grey100,
                child: Container(
                  width: 200,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Shimmer.fromColors(
                baseColor: AppColors.grey200,
                highlightColor: AppColors.grey100,
                child: Container(
                  width: 150,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => context.read<CurrentUserBloc>().add(
            const CurrentUserEvent.loadCurrentUser(),
          ),
          child: SvgPicture.asset(
            Assets.icons.repeatIcon,
            colorFilter: const ColorFilter.mode(
              AppColors.black,
              BlendMode.srcIn,
            ),
            fit: BoxFit.none,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadedState(AddressBookUser user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Avatar with initials
        CircleAvatar(
          radius: 20,
          backgroundColor: getAvatarColor(user.id),
          child: Text(
            getInitials(user.firstName, user.lastName),
            style: AppTypography.textSemibold1.white,
          ),
        ),
        const SizedBox(width: 8),
        // User info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.title,
                style: AppTypography.titleBold4.black,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // if (user.position != null && user.position!.isNotEmpty)
              Text(
                // user.position!,
                'Руководитель проектного офиса (Hardcoded)',
                style: AppTypography.captionMedium2.grey700,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // Notification bell with badge
        BlocBuilder<UnreadNotificationsCubit, int>(
          builder: (context, unreadCount) {
            return SizedBox(
              width: 40,
              height: 40,
              child: InkWell(
                onTap: () => context.push('/notifications'),
                borderRadius: BorderRadius.circular(22),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: unreadCount > 0
                      ? SvgPicture.asset(Assets.icons.bellWithGreenCircleIcon)
                      : SvgPicture.asset(Assets.icons.bellIcon),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Row(
      children: [
        // Shimmer effect placeholder
        Shimmer.fromColors(
          baseColor: AppColors.grey200,
          highlightColor: AppColors.grey100,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.grey200,
                highlightColor: AppColors.grey100,
                child: Container(
                  width: 200,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Shimmer.fromColors(
                baseColor: AppColors.grey200,
                highlightColor: AppColors.grey100,
                child: Container(
                  width: 150,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Shimmer.fromColors(
          baseColor: AppColors.grey500,
          highlightColor: AppColors.grey100,
          child: SvgPicture.asset(Assets.icons.bellIcon),
        ),
      ],
    );
  }
}
