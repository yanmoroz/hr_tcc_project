import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../notifications/notifications.dart';
import '../../domain/domain.dart';
import '../blocs/current_user/bloc.dart';

class UserProfileHeader extends StatelessWidget {
  final bool enableCorners;
  const UserProfileHeader({this.child, super.key, this.enableCorners = true});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserBloc, CurrentUserState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(enableCorners ? 12 : 0),
              bottomRight: Radius.circular(enableCorners ? 12 : 0),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, state),
              if (child != null) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 16),
                  child: child!,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, CurrentUserState state) {
    if (state.status == LoadingStatus.loading ||
        state.status == LoadingStatus.initial) {
      return _buildLoadingPlaceholder();
    }

    if (state.status == LoadingStatus.error) {
      return _buildErrorHeader(context, state.errorMessage ?? 'Unknown error');
    }

    // Success state
    final user = state.user;

    if (user == null) {
      return _buildLoadingPlaceholder();
    }

    return _buildLoadedHeader(context, user);
  }

  Widget _buildLoadingPlaceholder() {
    return Row(
      children: [
        // Shimmer effect placeholder
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.grey200,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 100,
                height: 14,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoadedHeader(BuildContext context, AddressBookUser user) {
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
              width: 44,
              height: 44,
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

  Widget _buildErrorHeader(BuildContext context, String message) {
    return Row(
      children: [
        Icon(Icons.error_outline, color: AppColors.red500),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Ошибка загрузки профиля',
            style: AppTypography.textRegular1.grey700,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.refresh, size: 24),
          color: AppColors.blue500,
          onPressed: () {
            context.read<CurrentUserBloc>().add(
              const CurrentUserEvent.refreshCurrentUser(),
            );
          },
        ),
      ],
    );
  }
}
