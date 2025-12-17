import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/color_utils.dart';
import '../../../../core/utils/string_utils.dart';
import '../../../../core/widgets/like_button.dart';
import '../../domain/domain.dart';

class CommentItem extends StatelessWidget {
  // TODO: Replace with actual current user ID from auth
  static const int _currentUserId = 20370;
  final Comment comment;
  final String? parentAuthorName;
  final String? parentComment;
  final VoidCallback onLike;
  final VoidCallback? onDelete;
  final VoidCallback? onReply;
  final VoidCallback? onParentTap;

  final bool isLastInGroup;

  const CommentItem({
    super.key,
    required this.comment,
    this.parentAuthorName,
    this.parentComment,
    required this.onLike,
    this.onDelete,
    this.onReply,
    this.onParentTap,
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
                    // Reply indicator
                    if (parentAuthorName != null &&
                        parentComment != null &&
                        onParentTap != null) ...[
                      InkWell(
                        onTap: onParentTap,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.grey100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(width: 2, color: AppColors.blue700),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      10,
                                      2,
                                      10,
                                      3,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'В ответ $parentAuthorName',
                                          style:
                                              AppTypography.textMedium2.blue700,
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          '$parentComment',
                                          style: AppTypography
                                              .captionMedium2
                                              .black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                    ],
                    // Author name and timestamp
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            comment.author.title,
                            style: AppTypography.textSemibold2.black,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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

  Widget _buildLikeButton() {
    final (
      likedColor,
      notLikedColor,
      textStyleLiked,
      textStyleNotLiked,
    ) = _isCurrentUser
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
      isLiked: comment.like ?? false,
      likeCount: comment.likeCount ?? 0,
      likedIconColor: likedColor,
      notLikedIconColor: notLikedColor,
      likedTextStyle: textStyleLiked,
      notLikedTextStyle: textStyleNotLiked,
      spacing: 4,
      iconSize: 20,
      onPressed: onLike,
    );
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}
