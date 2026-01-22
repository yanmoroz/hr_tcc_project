import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../news/presentation/view_models/news_item_view_model.dart';
import '../../../news/presentation/widgets/news_item.dart';

class NewsSection extends StatelessWidget {
  final List<NewsItemViewModel> newsItems;

  const NewsSection({super.key, required this.newsItems});

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Новости', style: AppTypography.textSemibold1.black),
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
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final newsItem = newsItems[index];
            return NewsItemWidget(
              viewModel: newsItem,
              onTap: () => context.push('/home/news/${newsItem.newsItem.id}'),
              onCommentsTap: () => context.push(
                '/home/comments/news/${newsItem.newsItem.id}',
                extra: {'entityName': newsItem.newsItem.title},
              ),
            );
          },
        ),
      ],
    );
  }
}
