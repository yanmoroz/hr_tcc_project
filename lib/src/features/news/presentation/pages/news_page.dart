import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_types/loading_status.dart';
import '../blocs/news_page/bloc.dart';
import '../widgets/news_item.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<NewsListBloc>().add(const NewsListEvent.loadMoreNews());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsListBloc, NewsListState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('News')),
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, NewsListState state) {
    if (state.status == LoadingStatus.loading || state.status == LoadingStatus.initial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == LoadingStatus.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error: ${state.errorMessage ?? 'Unknown error'}',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final args =
                    ModalRoute.of(context)?.settings.arguments
                        as Map<String, dynamic>?;
                final categoryCode = args?['category'] as int?;
                final searchQuery = args?['search'] as String?;
                context.read<NewsListBloc>().add(
                  NewsListEvent.loadNews(
                    category: categoryCode,
                    search: searchQuery,
                  ),
                );
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Success state
    final newsItems = state.newsItems;
    final isLoadingMore = state.isLoadingMore;
    final coverImages = state.coverImages;
    final category = state.category;
    final search = state.search;

    if (newsItems.isEmpty) {
      return const Center(child: Text('No news available'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<NewsListBloc>().add(
          NewsListEvent.refreshNews(
            category: category,
            search: search,
          ),
        );
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: newsItems.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= newsItems.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final newsItem = newsItems[index];
          return NewsItemWidget(
            newsItem: newsItem,
            coverImage: coverImages[newsItem.id],
            onTap: () {
              context.push('/home/news/${newsItem.id}');
            },
          );
        },
      ),
    );
  }
}
