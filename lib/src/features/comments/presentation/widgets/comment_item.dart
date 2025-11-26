import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/string_utils.dart';
import '../../domain/domain.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback onLike;
  final VoidCallback? onDelete;
  final VoidCallback? onReply;

  // TODO: Replace with actual current user ID from auth
  static const int _currentUserId = 20370;

  const CommentItem({
    super.key,
    required this.comment,
    required this.onLike,
    this.onDelete,
    this.onReply,
  });

  bool get _isCurrentUser => comment.author.id == _currentUserId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
              constraints: const BoxConstraints(maxWidth: 247),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Author name and timestamp
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            comment.author.title,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          _formatTime(comment.createdData),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Comment content
                    Text(
                      comment.content,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),

                    // Like and action buttons
                    Row(
                      children: [
                        // Like button
                        InkWell(
                          onTap: onLike,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 0,
                              vertical: 0,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  (comment.like ?? false)
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  size: 20,
                                  color: const Color(0xFF0A3899),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${comment.likeCount ?? 0}',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Delete button for current user, Reply for others
                        if (_isCurrentUser && onDelete != null)
                          InkWell(
                            onTap: onDelete,
                            borderRadius: BorderRadius.circular(20),
                            child: Text(
                              'Удалить',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          )
                        else if (!_isCurrentUser && onReply != null)
                          InkWell(
                            onTap: onReply,
                            borderRadius: BorderRadius.circular(20),
                            child: Text(
                              'Ответить',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
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
      backgroundColor: const Color(0xFF0A3899),
      child: Text(
        getInitialsFromFullName(comment.author.title),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}
