import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/comments_button.dart';
import '../../../../core/widgets/like_button.dart';
import '../view_models/news_item_view_model.dart';

class NewsItemWidget extends StatelessWidget {
  final NewsItemViewModel viewModel;
  final VoidCallback onTap;
  final VoidCallback onCommentsTap;

  const NewsItemWidget({
    super.key,
    required this.viewModel,
    required this.onTap,
    required this.onCommentsTap,
  });

  @override
  Widget build(BuildContext context) {
    final newsItem = viewModel.newsItem;
    final coverImage = viewModel.coverImage;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
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
                  child: Image.memory(coverImage),
                ),
              if (coverImage != null) const SizedBox(height: 12),

              // Timestamp
              Text(
                _formatDateTime(newsItem.createdData),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Color(0xFF767679),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                newsItem.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Summary
              if (newsItem.summary != null)
                Text(
                  newsItem.summary!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF767679),
                  ),
                  maxLines: 4,
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
                    likedTextStyle: AppTypography.textMedium2.black,
                    notLikedTextStyle: AppTypography.textMedium2.black,
                    likedIconColor: AppColors.blue500,
                    notLikedIconColor: AppColors.black,
                    onPressed: () {
                      // TODO:
                    },
                  ),
                  const SizedBox(width: 16),

                  // Comments
                  CommentsButton(
                    commentCount: newsItem.commentCount,
                    onPressed: () {
                      onCommentsTap();
                    },
                  ),

                  const Spacer(),

                  // Category badge
                  if (newsItem.categoryName != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDAE0EF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        newsItem.categoryName!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
