import 'package:flutter/material.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../core/widgets/like_button.dart';

/// A widget that displays action buttons for a comment.
///
/// Shows a like button and either a delete button (for current user's comments)
/// or a reply button (for other users' comments).
class CommentActionBar extends StatelessWidget {
  final bool isLiked;
  final int likeCount;
  final VoidCallback onLike;
  final VoidCallback? onDelete;
  final VoidCallback? onReply;
  final bool isCurrentUser;

  const CommentActionBar({
    super.key,
    required this.isLiked,
    required this.likeCount,
    required this.onLike,
    this.onDelete,
    this.onReply,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildLikeButton(),
        const Spacer(),
        if (isCurrentUser && onDelete != null)
          _ActionButton(label: 'Удалить', onTap: onDelete!)
        else if (!isCurrentUser && onReply != null)
          _ActionButton(label: 'Ответить', onTap: onReply!),
      ],
    );
  }

  Widget _buildLikeButton() {
    final (
      likedColor,
      notLikedColor,
      textStyleLiked,
      textStyleNotLiked,
    ) = isCurrentUser
        ? (
            AppColors.grey200,
            AppColors.grey200,
            AppTypography.textMedium2.grey500,
            AppTypography.textMedium2.grey500,
          )
        : (
            AppColors.blue500,
            AppColors.grey500,
            AppTypography.textMedium2.blue700,
            AppTypography.textMedium2.grey500,
          );

    return LikeButton(
      isLiked: isLiked,
      likeCount: likeCount,
      likedIconColor: likedColor,
      notLikedIconColor: notLikedColor,
      likedTextStyle: textStyleLiked,
      notLikedTextStyle: textStyleNotLiked,
      spacing: 4,
      iconSize: 20,
      onPressed: onLike,
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Text(label, style: AppTypography.textMedium2.grey500),
    );
  }
}
