import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/utils/pluralization.dart';
import '../../domain/domain.dart';
import '../blocs/comments_page/bloc.dart';
import '../widgets/comment_item.dart';
import '../widgets/comment_input_bar.dart';
import '../widgets/date_separator.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _inputFocusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F6),
      appBar: AppBar(
        title: BlocBuilder<CommentsBloc, CommentsState>(
          builder: (context, state) {
            final commentCount = state.comments.length;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      switch (context.read<CommentsBloc>().entityType) {
                        CommentableEntityType.news =>
                          'Новости «${context.read<CommentsBloc>().entityName}»',
                        CommentableEntityType.discount =>
                          'Льготы и можности «${context.read<CommentsBloc>().entityName}»',
                      },
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF767679),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Comments list
          Expanded(
            child: BlocListener<CommentsBloc, CommentsState>(
              listenWhen: (previous, current) {
                // Listen when a comment is successfully added
                return previous.isAddingComment == true &&
                    current.isAddingComment == false &&
                    current.status == LoadingStatus.success &&
                    current.comments.length > previous.comments.length;
              },
              listener: (context, state) {
                _scrollController.jumpTo(0);
              },
              child: BlocBuilder<CommentsBloc, CommentsState>(
                builder: (context, state) {
                  if (state.status == LoadingStatus.initial ||
                      state.status == LoadingStatus.loading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.status == LoadingStatus.error) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Ошибка: ${state.errorMessage ?? 'Unknown error'}',
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
                    );
                  }

                  if (state.comments.isEmpty) {
                    return const Center(child: Text('Комментариев пока нет'));
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<CommentsBloc>().add(
                        const CommentsEvent.refreshComments(),
                      );
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: state.groupedComments.length,
                      itemBuilder: (context, index) {
                        final group = state.groupedComments[index];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date separator at the end (appears at top due to reverse)
                            DateSeparator(date: group.date),
                            // Comments for this day
                            ...group.comments.asMap().entries.map((entry) {
                              final commentIndex = entry.key;
                              final comment = entry.value;
                              final isLastInGroup =
                                  commentIndex == group.comments.length - 1;
                              return CommentItem(
                                comment: comment,
                                isLastInGroup: isLastInGroup,
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
                                  context.read<CommentsBloc>().add(
                                    CommentsEvent.startReply(comment),
                                  );
                                  // Focus the input field after state update
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    _inputFocusNode.requestFocus();
                                  });
                                },
                              );
                            }),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),

          CommentInputBar(
            controller: _commentController,
            focusNode: _inputFocusNode,
            onSend: (content, parentId) {
              context.read<CommentsBloc>().add(
                CommentsEvent.addComment(content: content, parentId: parentId),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, int commentId) {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (dialogContext) => CupertinoAlertDialog(
          title: const Text('Удалить комментарий'),
          content: const Text(
            'Вы уверены, что хотите удалить этот комментарий?',
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Отмена'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                context.read<CommentsBloc>().add(
                  CommentsEvent.deleteComment(commentId),
                );
                Navigator.pop(dialogContext);
              },
              child: const Text('Удалить'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Удалить комментарий'),
          content: const Text(
            'Вы уверены, что хотите удалить этот комментарий?',
          ),
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
  }

  String _getCommentCountText(int count) {
    return pluralizeRu(
      count,
      '$count комментарий',
      '$count комментария',
      '$count комментариев',
    );
  }
}
