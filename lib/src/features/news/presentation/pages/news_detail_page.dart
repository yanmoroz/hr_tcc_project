import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/comments_button.dart';
import '../../../../core/widgets/like_button.dart';
import '../bloc/news_detail_page/bloc.dart';

class NewsDetailPage extends StatelessWidget {
  final int newsId;

  const NewsDetailPage({super.key, required this.newsId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsDetailBloc, NewsDetailState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('News Detail')),
          body: state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (newsDetail, likeCount, liked, commentCount, coverImage) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<NewsDetailBloc>().add(
                    const NewsDetailEvent.refresh(),
                  );
                },
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      if (coverImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            coverImage,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 200,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 64,
                                ),
                              );
                            },
                          ),
                        ),
                      if (coverImage != null) const SizedBox(height: 16),

                      // Title
                      Text(
                        newsDetail.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // Date
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(newsDetail.createdData),
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Content (HTML)
                      if (newsDetail.content.isNotEmpty) ...[
                        Text(
                          'Content',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Html(data: newsDetail.content),
                        const SizedBox(height: 16),
                      ],

                      // Author
                      Card(
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(
                            '${newsDetail.author.firstName} ${newsDetail.author.lastName}',
                          ),
                          subtitle: newsDetail.author.title.isNotEmpty
                              ? Text(newsDetail.author.title)
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Like and Comment buttons
                      Row(
                        children: [
                          LikeButton(
                            isLiked: liked,
                            likeCount: likeCount,
                            onPressed: () {
                              context.read<NewsDetailBloc>().add(
                                const NewsDetailEvent.toggleLike(),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          CommentsButton(
                            commentCount: commentCount,
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/comments',
                                arguments: {
                                  'entityId': newsId,
                                  'feature': 'news',
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: $message',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NewsDetailBloc>().add(
                        const NewsDetailEvent.loadDetail(),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }
}
