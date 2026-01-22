import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../users/users.dart';

/// A widget that displays a list of users for mention selection.
///
/// Shows a loading indicator while fetching users, an empty state message
/// when no users are found, or a scrollable list of user tiles.
class MentionOverlay extends StatelessWidget {
  /// The list of users to display.
  final List<User> users;

  /// Whether the user list is currently loading.
  final bool isLoading;

  /// Callback when a user is selected from the list.
  final void Function(User user) onUserSelected;

  /// Maximum height of the overlay. Defaults to 200.
  final double maxHeight;

  const MentionOverlay({
    super.key,
    required this.users,
    required this.isLoading,
    required this.onUserSelected,
    this.maxHeight = 152,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        border: Border.all(color: AppColors.grey200),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.blue700,
            ),
          ),
        ),
      );
    }

    if (users.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Пользователи не найдены',
          style: AppTypography.textRegular2.grey700,
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: users.length,
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(left: 56),
        child: const Divider(height: 0.5, color: AppColors.grey200),
      ),
      itemBuilder: (context, index) {
        final user = users[index];
        return _MentionUserTile(user: user, onTap: () => onUserSelected(user));
      },
    );
  }
}

class _MentionUserTile extends StatelessWidget {
  final User user;
  final VoidCallback onTap;

  const _MentionUserTile({required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        child: Row(
          children: [
            UserAvatar.fromFullName(fullName: user.title, radius: 14),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                user.title,
                style: AppTypography.textMedium2.black,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
