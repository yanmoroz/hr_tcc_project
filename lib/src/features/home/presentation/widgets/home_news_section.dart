import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../news/presentation/blocs/news_page/bloc.dart';
import '../../../news/presentation/widgets/news_item.dart';

class HomeNewsSection extends StatelessWidget {
  const HomeNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                'Новости',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => context.push('/home/news'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Перейти в раздел',
                  style: TextStyle(
                    color: const Color(0xFF0A3899),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // News list
        BlocBuilder<NewsListBloc, NewsListState>(
          builder: (context, state) {
            return _buildContent(context, state);
          },
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, NewsListState state) {
    if (state.status == LoadingStatus.initial) {
      return const SizedBox.shrink();
    }

    if (state.status == LoadingStatus.loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (state.status == LoadingStatus.error) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Не удалось загрузить новости',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.push('/home/news'),
              child: const Text('Перейти к новостям'),
            ),
          ],
        ),
      );
    }

    // Success state
    final newsItems = state.newsItems;
    final coverImages = state.coverImages;

    if (newsItems.isEmpty) {
      return const SizedBox.shrink();
    }

    final latestNews = newsItems.toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: latestNews
            .map(
              (newsItem) => NewsItemWidget(
                newsItem: newsItem,
                coverImage: coverImages[newsItem.id],
                onTap: () => context.push('/home/news/${newsItem.id}'),
                onCommentsTap: () =>
                    context.push('/home/comments/news/${newsItem.id}'),
              ),
            )
            .toList(),
      ),
    );
  }
}
