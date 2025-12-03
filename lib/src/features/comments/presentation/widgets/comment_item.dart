import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../core/widgets/like_button.dart';
import '../../domain/domain.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback onLike;
  final VoidCallback? onDelete;
  final VoidCallback? onReply;
  final bool isLastInGroup;

  // TODO: Replace with actual current user ID from auth
  static const int _currentUserId = 20370;

  const CommentItem({
    super.key,
    required this.comment,
    required this.onLike,
    this.onDelete,
    this.onReply,
    this.isLastInGroup = false,
  });

  bool get _isCurrentUser => comment.author.id == _currentUserId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLastInGroup ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: _isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          // Avatar on left for other users
          if (!_isCurrentUser) ...[_buildAvatar(), const SizedBox(width: 12)],
          // Comment content container
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 150,
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author name and timestamp
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            comment.author.title,
                            style: AppTypography.textSemibold2.black,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(
                          _formatTime(comment.createdData),
                          style: AppTypography.captionMedium3.grey500,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Comment content
                    Text(
                      comment.content,
                      style: AppTypography.textRegular2.black,
                    ),
                    const SizedBox(height: 12),

                    // Like and action buttons
                    Row(
                      children: [
                        // Like button
                        _buildLikeButton(),
                        const Spacer(),
                        // Delete button for current user, Reply for others
                        if (_isCurrentUser && onDelete != null)
                          InkWell(
                            onTap: onDelete,
                            borderRadius: BorderRadius.circular(20),
                            child: Text(
                              'Удалить',
                              style: AppTypography.textMedium2.grey500,
                            ),
                          )
                        else if (!_isCurrentUser && onReply != null)
                          InkWell(
                            onTap: onReply,
                            borderRadius: BorderRadius.circular(20),
                            child: Text(
                              'Ответить',
                              style: AppTypography.textMedium2.grey500,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Avatar on right for current user
          if (_isCurrentUser) ...[const SizedBox(width: 12), _buildAvatar()],
        ],
      ),
    );
  }

  Widget _buildLikeButton() {
    if (_isCurrentUser) {
      // Current user's comment - use different styling
      return LikeButton(
        isLiked: comment.like ?? false,
        likeCount: comment.likeCount ?? 0,
        likedIconColor: AppColors.grey200,
        notLikedIconColor: AppColors.grey200,
        likedTextStyle: AppTypography.textMedium2.grey500,
        notLikedTextStyle: AppTypography.textMedium2.grey500,
        spacing: 4,
        iconSize: 20,
        onPressed: onLike,
      );
    }

    // Another user's comment - use different styling
    return LikeButton(
      isLiked: comment.like ?? false,
      likeCount: comment.likeCount ?? 0,
      likedIconColor: AppColors.blue500,
      notLikedIconColor: AppColors.grey500,
      likedTextStyle: AppTypography.textMedium2.blue700,
      notLikedTextStyle: AppTypography.textMedium2.grey500,
      spacing: 4,
      iconSize: 20,
      onPressed: onLike,
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 16,
      backgroundColor: getAvatarColor(comment.author.title),
      child: Text(
        getInitialsFromFullName(comment.author.title),
        style: AppTypography.textSemibold2.white,
      ),
    );
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}
