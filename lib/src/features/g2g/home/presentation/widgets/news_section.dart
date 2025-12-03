import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/theme.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../../news/domain/domain.dart';
import '../../../../news/presentation/widgets/news_item.dart';

class NewsSection extends StatelessWidget {
  final List<NewsItem> newsItems;
  final Map<int, Uint8List> coverImages;

  const NewsSection({
    super.key,
    required this.newsItems,
    required this.coverImages,
  });

  @override
  Widget build(BuildContext context) {
    if (newsItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Text('Новости', style: AppTypography.textSemibold1.black),
            const Spacer(),
            AppTextButton(
              onPressed: () => context.push('/home/news'),
              child: Text(
                'Перейти в раздел',
                style: AppTypography.textRegular2.blue700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // News list
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: newsItems.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final newsItem = newsItems[index];
            return NewsItemWidget(
              newsItem: newsItem,
              coverImage: coverImages[newsItem.id],
              onTap: () => context.push('/home/news/${newsItem.id}'),
              onCommentsTap: () => context.push(
                '/home/comments/news/${newsItem.id}',
                extra: {'entityName': newsItem.title},
              ),
            );
          },
        ),
      ],
    );
  }
}
