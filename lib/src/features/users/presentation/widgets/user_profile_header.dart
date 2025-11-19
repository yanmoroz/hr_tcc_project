import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../domain/domain.dart';
import '../blocs/user_profile_header/bloc.dart';

class UserProfileHeader extends StatelessWidget {
  const UserProfileHeader({this.child, super.key});

  final Widget? child;

  String _getInitials(AddressBookUser user) {
    final first = user.firstName.isNotEmpty ? user.firstName[0] : '';
    final last = user.lastName.isNotEmpty ? user.lastName[0] : '';
    return '$first$last'.toUpperCase();
  }

  Color _getAvatarColor(String userId) {
    final hash = userId.hashCode;
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[hash.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileHeaderBloc, UserProfileHeaderState>(
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
              SizedBox(
                height: 56,
                child: state.when(
                  initial: () => _buildLoadingPlaceholder(),
                  loading: () => _buildLoadingPlaceholder(),
                  loaded: (user) => _buildLoadedHeader(context, user),
                  error: (message) => _buildErrorHeader(context, message),
                ),
              ),
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
        Icon(Icons.notifications_outlined, size: 24, color: Colors.grey[400]),
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
          backgroundColor: _getAvatarColor(user.id),
          child: Text(
            _getInitials(user),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // User info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                user.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (user.position != null && user.position!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    user.position!,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        // Notification bell
        IconButton(
          icon: SvgPicture.asset('assets/icons/bell-icon.svg'),
          color: const Color(0xFF0A3899),
          onPressed: () => context.push('/notifications'),
          padding: const EdgeInsets.all(0),
          constraints: const BoxConstraints(),
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
            context.read<UserProfileHeaderBloc>().add(
              const UserProfileHeaderEvent.refreshUserProfile(),
            );
          },
        ),
      ],
    );
  }
}
