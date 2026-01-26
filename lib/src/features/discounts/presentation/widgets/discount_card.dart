import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/comments_button.dart';
import '../../../../core/widgets/like_button.dart';
import '../../domain/domain.dart';

class DiscountCard extends StatelessWidget {
  final Discount discount;
  final VoidCallback onTap;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;

  const DiscountCard({
    super.key,
    required this.discount,
    required this.onTap,
    required this.onLikeTap,
    required this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: AppColors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4A7FD5), Color(0xFF2E5FB8)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Stack(
                children: [
                  // Main content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Duration badge
                      Text(
                        _getDurationText(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Category tag
                      if (discount.category != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            discount.category!.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Title
                      Text(
                        discount.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Description
                      if (discount.shortDescription != null) ...[
                        Text(
                          discount.shortDescription!,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                      ],

                      // Like and comment counts
                      Row(
                        children: [
                          // Likes
                          LikeButton(
                            isLiked: discount.like,
                            likeCount: discount.likeCount,
                            spacing: 4,
                            iconSize: 24,
                            likedTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            notLikedTextStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                            likedIconColor: Colors.white,
                            notLikedIconColor: Colors.white,
                            onPressed: onLikeTap,
                          ),
                          const SizedBox(width: 16),

                          // Comments
                          CommentsButton(
                            commentCount: discount.commentCount,
                            textColor: Colors.white,
                            iconColor: Colors.white,
                            onPressed: onCommentTap,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getDurationText() {
    if (discount.dateTo == null) {
      return 'Бессрочно';
    }
    return 'До ${DateFormat('dd.MM.yyyy').format(discount.dateTo!)}';
  }
}
