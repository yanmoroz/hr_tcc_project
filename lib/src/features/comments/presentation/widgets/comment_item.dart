import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/domain.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback onLike;
  final VoidCallback? onDelete;
  final VoidCallback? onReply;

  const CommentItem({
    super.key,
    required this.comment,
    required this.onLike,
    this.onDelete,
    this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar with initials - positioned to the left and bottom-aligned
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF0A3899),
            child: Text(
              _getInitials(comment.author.title),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
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

                    // Like and reply buttons
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
                        if (onReply != null) ...[
                          const Spacer(),
                          InkWell(
                            onTap: onReply,
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 0,
                              ),
                              child: Text(
                                'Ответить',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      return parts[0].substring(0, 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}
