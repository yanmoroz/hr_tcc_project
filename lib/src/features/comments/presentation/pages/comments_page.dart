import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/pluralization.dart';
import '../../../../core/widgets/widgets.dart';
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.grey100,
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
                    style: AppTypography.textRegular2.grey700,
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
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(switch (context
                          .read<CommentsBloc>()
                          .entityType) {
                        CommentableEntityType.news =>
                          'Новости «${context.read<CommentsBloc>().entityName}»',
                        CommentableEntityType.discount =>
                          'Льготы и можности «${context.read<CommentsBloc>().entityName}»',
                      }, style: AppTypography.textRegular2.grey700),
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
                    return switch (state.status) {
                      LoadingStatus.initial => _buildLoadingState(
                        context,
                        state,
                      ),
                      LoadingStatus.loading => _buildLoadingState(
                        context,
                        state,
                      ),
                      LoadingStatus.error => _buildErrorState(context, state),
                      LoadingStatus.success => _buildLoadedState(
                        context,
                        state,
                      ),
                    };
                  },
                ),
              ),
            ),

            BlocBuilder<CommentsBloc, CommentsState>(
              builder: (context, state) {
                return switch (state.status) {
                  LoadingStatus.initial => const SizedBox.shrink(),
                  LoadingStatus.loading => const SizedBox.shrink(),
                  LoadingStatus.error => const SizedBox.shrink(),
                  LoadingStatus.success => CommentInputBar(
                    controller: _commentController,
                    focusNode: _inputFocusNode,
                    onSend: (content, parentId) {
                      context.read<CommentsBloc>().add(
                        CommentsEvent.addComment(
                          content: content,
                          parentId: parentId,
                        ),
                      );
                    },
                  ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context, CommentsState state) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Shimmer.fromColors(
                      baseColor: AppColors.grey200,
                      highlightColor: AppColors.grey100,
                      child: SizedBox(
                        height: 125,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.grey200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemCount: 10,
                  ),
                ),
                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, CommentsState state) {
    return NetworkErrorMessageWidget(
      onRetry: () =>
          context.read<CommentsBloc>().add(const CommentsEvent.loadComments()),
    );
  }

  Widget _buildLoadedState(BuildContext context, CommentsState state) {
    if (state.comments.isEmpty) {
      return Center(
        child: Text(
          'Комментариев пока нет',
          style: AppTypography.textRegular1.black,
        ),
      );
    }

    return ListView.builder(
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
            ...group.comments.indexed.map((record) {
              final (index, comment) = record;
              final isLastInGroup = index == group.comments.length - 1;
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
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _inputFocusNode.requestFocus();
                  });
                },
              );
            }),
          ],
        );
      },
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
              child: const Text(
                'Отмена',
                style: TextStyle(color: AppColors.black),
              ),
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
              child: const Text(
                'Отмена',
                style: TextStyle(color: AppColors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<CommentsBloc>().add(
                  CommentsEvent.deleteComment(commentId),
                );
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Удалить',
                style: TextStyle(color: AppColors.red500),
              ),
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
