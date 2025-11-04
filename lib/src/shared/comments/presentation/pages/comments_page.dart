import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/bloc_factory.dart';
import '../bloc/comments_page/comments_bloc.dart';
import '../bloc/comments_page/comments_event.dart';
import '../bloc/comments_page/comments_state.dart';
import '../../domain/domain.dart';

class CommentsPage extends StatefulWidget {
  final int entityId;

  const CommentsPage({super.key, required this.entityId});

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
    return BlocProvider(
      create: (context) => BlocFactory.createCommentsBloc(widget.entityId)..add(const CommentsEvent.loadComments()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Comments')),
        body: Column(
          children: [
            // Comments list
            Expanded(
              child: BlocBuilder<CommentsBloc, CommentsState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const Center(child: CircularProgressIndicator()),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    loaded: (comments, isAddingComment) {
                      if (comments.isEmpty) {
                        return const Center(child: Text('No comments yet'));
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<CommentsBloc>().add(const CommentsEvent.refreshComments());
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            final comment = comments[index];
                            return _CommentItem(
                              comment: comment,
                              onLike: () {
                                context.read<CommentsBloc>().add(CommentsEvent.toggleCommentLike(comment.id));
                              },
                              onDelete: comment.editable
                                  ? () {
                                      _showDeleteDialog(context, comment.id);
                                    }
                                  : null,
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
                            'Error: $message',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<CommentsBloc>().add(const CommentsEvent.loadComments());
                            },
                            child: const Text('Retry'),
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
                final isAddingComment = state.maybeWhen(loaded: (_, isAdding) => isAdding, orElse: () => false);

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, -2)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            hintText: 'Write a comment...',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: null,
                          enabled: !isAddingComment,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: isAddingComment
                            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.send),
                        onPressed: isAddingComment
                            ? null
                            : () {
                                if (_commentController.text.trim().isNotEmpty) {
                                  context.read<CommentsBloc>().add(
                                    CommentsEvent.addComment(content: _commentController.text.trim()),
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
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int commentId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<CommentsBloc>().add(CommentsEvent.deleteComment(commentId));
              Navigator.pop(dialogContext);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback onLike;
  final VoidCallback? onDelete;

  const _CommentItem({required this.comment, required this.onLike, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Author info
            Row(
              children: [
                CircleAvatar(radius: 16, child: Text(comment.author.title[0].toUpperCase())),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.author.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (comment.author.position != null)
                        Text(comment.author.position!, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                if (onDelete != null)
                  IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: onDelete, color: Colors.red),
              ],
            ),
            const SizedBox(height: 8),

            // Content
            Text(comment.content),
            const SizedBox(height: 8),

            // Date and like button
            Row(
              children: [
                Text(
                  _formatDate(comment.createdData),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    (comment.like ?? false) ? Icons.favorite : Icons.favorite_border,
                    size: 20,
                    color: (comment.like ?? false) ? Colors.red : null,
                  ),
                  onPressed: onLike,
                ),
                Text('${comment.likeCount ?? 0}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy HH:mm').format(date);
  }
}
