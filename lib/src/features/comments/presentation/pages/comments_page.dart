import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/domain.dart';
import '../bloc/comments_page/bloc.dart';
import '../widgets/comment_item.dart';
import '../widgets/date_separator.dart';

class CommentsPage extends StatefulWidget {
  final int entityId;
  final CommentableEntityType entityType;

  const CommentsPage({
    super.key,
    required this.entityId,
    required this.entityType,
  });

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F6),
      appBar: AppBar(
        title: BlocBuilder<CommentsBloc, CommentsState>(
          builder: (context, state) {
            final commentCount = state.maybeWhen(
              loaded: (comments, _) => comments.length,
              orElse: () => 0,
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Комментарии'),
                Text(
                  _getCommentCountText(commentCount),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Comments list
          Expanded(
            child: BlocBuilder<CommentsBloc, CommentsState>(
              builder: (context, state) {
                return state.when(
                  initial: () =>
                      const Center(child: CircularProgressIndicator()),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  loaded: (comments, isAddingComment) {
                    if (comments.isEmpty) {
                      return const Center(child: Text('Комментариев пока нет'));
                    }

                    // Sort comments by createdData (ascending - oldest first)
                    final sortedComments = List<Comment>.from(comments)
                      ..sort((a, b) => a.createdData.compareTo(b.createdData));

                    // Group comments by day
                    final groupedItems = _groupCommentsByDay(sortedComments);

                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<CommentsBloc>().add(
                          const CommentsEvent.refreshComments(),
                        );
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: groupedItems.length,
                        itemBuilder: (context, index) {
                          final item = groupedItems[index];

                          // Check if this is a date separator
                          if (item is DateTime) {
                            return DateSeparator(date: item);
                          }

                          // Otherwise it's a Comment
                          final comment = item as Comment;
                          return CommentItem(
                            comment: comment,
                            onLike: () {
                              context.read<CommentsBloc>().add(
                                CommentsEvent.toggleCommentLike(comment.id),
                              );
                            },
                            onDelete: comment.editable
                                ? () {
                                    _showDeleteDialog(context, comment.id);
                                  }
                                : null,
                            onReply: () {
                              // TODO: Implement reply functionality
                            },
                          );
                        },
                      ),
                    );
                  },
                  error: (message) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ошибка: $message',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<CommentsBloc>().add(
                              const CommentsEvent.loadComments(),
                            );
                          },
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Add comment input
          BlocBuilder<CommentsBloc, CommentsState>(
            builder: (context, state) {
              final isAddingComment = state.maybeWhen(
                loaded: (_, isAdding) => isAdding,
                orElse: () => false,
              );

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: const InputDecoration(
                          hintText: 'Ваш комментарий',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: null,
                        enabled: !isAddingComment,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: isAddingComment
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      onPressed: isAddingComment
                          ? null
                          : () {
                              if (_commentController.text.trim().isNotEmpty) {
                                context.read<CommentsBloc>().add(
                                  CommentsEvent.addComment(
                                    content: _commentController.text.trim(),
                                  ),
                                );
                                _commentController.clear();
                              }
                            },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int commentId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить комментарий'),
        content: const Text('Вы уверены, что хотите удалить этот комментарий?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<CommentsBloc>().add(
                CommentsEvent.deleteComment(commentId),
              );
              Navigator.pop(dialogContext);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  List<Object> _groupCommentsByDay(List<Comment> comments) {
    final List<Object> groupedItems = [];
    DateTime? lastDate;

    for (final comment in comments) {
      final commentDate = DateTime(
        comment.createdData.year,
        comment.createdData.month,
        comment.createdData.day,
      );

      // Add date separator if this is a new day
      if (lastDate == null || !_isSameDay(lastDate, commentDate)) {
        groupedItems.add(commentDate);
        lastDate = commentDate;
      }

      // Add the comment
      groupedItems.add(comment);
    }

    return groupedItems;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String _getCommentCountText(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return '$count комментарий';
    } else if ([2, 3, 4].contains(count % 10) &&
        ![12, 13, 14].contains(count % 100)) {
      return '$count комментария';
    } else {
      return '$count комментариев';
    }
  }
}
