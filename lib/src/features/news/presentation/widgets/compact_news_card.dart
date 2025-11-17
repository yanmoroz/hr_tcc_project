import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/comments_button.dart';
import '../../../../core/widgets/like_button.dart';
import '../../domain/domain.dart';

class CompactNewsCard extends StatelessWidget {
  final NewsItem newsItem;
  final VoidCallback onTap;
  final Uint8List? coverImage;

  const CompactNewsCard({
    super.key,
    required this.newsItem,
    required this.onTap,
    this.coverImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image (if available)
              if (coverImage != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.memory(
                    coverImage!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, size: 48),
                      );
                    },
                  ),
                ),
              if (coverImage != null) const SizedBox(height: 12),

              // Timestamp with green indicator
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDateTime(newsItem.createdData),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                newsItem.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Summary
              Text(
                newsItem.summary,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Bottom row: likes, comments, and category badge
              Row(
                children: [
                  // Likes
                  LikeButton(
                    isLiked: newsItem.like,
                    likeCount: newsItem.likeCount,
                  ),
                  const SizedBox(width: 16),

                  // Comments
                  CommentsButton(
                    commentCount: newsItem.commentCount,
                  ),

                  const Spacer(),

                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F4F8),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      newsItem.categoryName,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    final timeFormat = DateFormat('HH:mm');

    if (dateToCheck == today) {
      return 'Сегодня в ${timeFormat.format(date)}';
    } else {
      return '${DateFormat('dd.MM.yyyy').format(date)} в ${timeFormat.format(date)}';
    }
  }
}
