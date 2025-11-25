import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/base_types/loading_status.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../notifications/notifications.dart';
import '../../domain/domain.dart';
import '../blocs/current_user/bloc.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({this.child, super.key});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserBloc, CurrentUserState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 56, child: _buildHeader(context, state)),
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
            color: Colors.grey[300],
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
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 100,
                height: 14,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
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
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
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
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // if (user.position != null && user.position!.isNotEmpty)
              Text(
                // user.position!,
                'Руководитель проектного офиса (Hardcoded)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF767679),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        // Notification bell with badge
        BlocBuilder<UnreadNotificationsCubit, int>(
          builder: (context, unreadCount) {
            return IconButton(
              icon: unreadCount > 0
                  ? SvgPicture.asset(Assets.icons.bellWithGreenCircleIcon)
                  : SvgPicture.asset(Assets.icons.bellIcon),
              color: const Color(0xFF0A3899),
              onPressed: () => context.push('/notifications'),
              padding: const EdgeInsets.all(0),
              constraints: const BoxConstraints(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildErrorHeader(BuildContext context, String message) {
    return Row(
      children: [
        Icon(Icons.error_outline, color: Colors.red[300]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Ошибка загрузки профиля',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.refresh, size: 24),
          color: const Color(0xFF0A3899),
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
