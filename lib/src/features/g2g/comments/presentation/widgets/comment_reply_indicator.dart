import 'package:flutter/material.dart';

import '../../../../../core/theme/theme.dart';

/// A widget that displays a reply indicator showing the parent comment.
///
/// Used in comment items to show which comment is being replied to.
class CommentReplyIndicator extends StatelessWidget {
  static final _tagRegExp = RegExp(r'<[^>]*>');

  final String authorName;
  final String comment;
  final VoidCallback onTap;

  const CommentReplyIndicator({
    super.key,
    required this.authorName,
    required this.comment,
    required this.onTap,
  });

  String get _cleanComment =>
      comment.replaceAll(_tagRegExp, '').replaceAll('&nbsp;', ' ');

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
                        _cleanComment,
                        style: AppTypography.captionMedium2.black,
                        maxLines: 5,
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
