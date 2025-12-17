import 'package:flutter/material.dart';

import '../../../../core/theme/theme.dart';

/// A widget that displays a reply indicator showing the parent comment.
///
/// Used in comment items to show which comment is being replied to.
class CommentReplyIndicator extends StatelessWidget {
  final String authorName;
  final String comment;
  final VoidCallback onTap;

  const CommentReplyIndicator({
    super.key,
    required this.authorName,
    required this.comment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'В ответ $authorName',
                        style: AppTypography.textMedium2.blue700,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        comment,
                        style: AppTypography.captionMedium2.black,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
