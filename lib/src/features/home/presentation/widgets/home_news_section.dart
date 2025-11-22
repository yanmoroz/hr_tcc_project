import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../news/presentation/blocs/news_page/bloc.dart';
import '../../../news/presentation/widgets/compact_news_card.dart';

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Новости',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/news'),
                child: Text(
                  'Перейти в раздел',
                  style: TextStyle(
                    color: const Color(0xFF0A3899),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

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
              onPressed: () => context.push('/news'),
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

    // Show only latest 3 news items
    final latestNews = newsItems.take(3).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: latestNews
            .map(
              (newsItem) => CompactNewsCard(
                newsItem: newsItem,
                coverImage: coverImages[newsItem.id],
                onTap: () => context.push('/news-detail/${newsItem.id}'),
              ),
            )
            .toList(),
      ),
    );
  }
}
