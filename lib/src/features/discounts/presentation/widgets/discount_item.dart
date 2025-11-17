import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/comments_button.dart';
import '../../../../core/widgets/like_button.dart';
import '../../domain/domain.dart';

class DiscountItem extends StatelessWidget {
  final Discount discount;
  final VoidCallback onTap;
  final Uint8List? coverImage;

  const DiscountItem({
    super.key,
    required this.discount,
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

              // Title
              Text(
                discount.title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Short description
              if (discount.shortDescription != null)
                Text(
                  discount.shortDescription!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              if (discount.shortDescription != null) const SizedBox(height: 8),

              // Category
              if (discount.category != null)
                Chip(
                  label: Text(discount.category!.title),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),

              const SizedBox(height: 8),

              // Dates
              if (discount.dateFrom != null && discount.dateTo != null)
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${_formatDate(discount.dateFrom!)} - ${_formatDate(discount.dateTo!)}',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              const SizedBox(height: 8),

              // Author, likes, and comments
              Row(
                children: [
                  // Author
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            discount.author.title,
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Likes
                  LikeButton(
                    isLiked: discount.like,
                    likeCount: discount.likeCount,
                  ),
                  const SizedBox(width: 16),

                  // Comments
                  CommentsButton(
                    commentCount: discount.commentCount,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }
}
