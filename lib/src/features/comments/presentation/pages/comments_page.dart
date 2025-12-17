import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base_types/loading_status.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/pluralization.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/domain.dart';
import '../blocs/comments_page/bloc.dart';
import '../delegates/date_header_delegate.dart';
import '../widgets/comment_input_bar.dart';
import '../widgets/comment_item.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final entityType = context.read<CommentsBloc>().entityType;
    final entityName = context.read<CommentsBloc>().entityName;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
                      child: Text(switch (entityType) {
                        CommentableEntityType.news => 'Новости «$entityName»',
                        CommentableEntityType.discount =>
                          'Льготы и можности «$entityName»',
                      }, style: AppTypography.textRegular2.grey700),
                    ),
                  ],
                ),
              ),
            ),
            // Comments list with integrated header
            Expanded(
              child: MultiBlocListener(
                listeners: [
                  // Scroll to bottom on initial data load
                  BlocListener<CommentsBloc, CommentsState>(
                    listenWhen: (previous, current) {
                      return previous.status == LoadingStatus.loading &&
                          current.status == LoadingStatus.success;
                    },
                    listener: (context, state) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        scrollToBottomSafely();
                      });
                    },
                  ),
                  // Scroll to bottom when a comment is successfully added
                  BlocListener<CommentsBloc, CommentsState>(
                    listenWhen: (previous, current) {
                      return previous.isAddingComment == true &&
                          current.isAddingComment == false &&
                          current.status == LoadingStatus.success &&
                          current.comments.length > previous.comments.length;
                    },
                    listener: (context, state) {
                      scrollToBottomSafely();
                    },
                  ),
                ],
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

  @override
  void dispose() {
    _commentController.dispose();
    _inputFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> scrollToBottomSafely() async {
    if (!_scrollController.hasClients) return;

    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    await Future.delayed(const Duration(milliseconds: 50), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  Widget _buildErrorState(BuildContext context, CommentsState state) {
    return NetworkErrorMessageWidget(
      onRetry: () =>
          context.read<CommentsBloc>().add(const CommentsEvent.loadComments()),
    );
  }

  Widget _buildLoadedState(BuildContext context, CommentsState state) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Build SliverMainAxisGroups for each date group
        ...state.groupedComments.reversed.map((group) {
          return SliverMainAxisGroup(
            slivers: [
              // Date header
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: DateHeaderDelegate(date: group.date),
                ),
              ),
              // Comments list for this date
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, commentIndex) {
                    final comment = group.comments[commentIndex];
                    final isLastInGroup =
                        commentIndex == group.comments.length - 1;
                    final parentAuthorName = comment.parent != null
                        ? state.comments
                              .where((c) => c.id == comment.parent)
                              .firstOrNull
                              ?.author
                              .title
                        : null;
                    final parentComment = comment.parent != null
                        ? state.comments
                              .where((c) => c.id == comment.parent)
                              .firstOrNull
                              ?.content
                        : null;

                    return CommentItem(
                      comment: comment,
                      parentAuthorName: parentAuthorName,
                      parentComment: parentComment,
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
                      onParentTap: () {
                        _scrollToParentComment(state, comment.parent);
                      },
                    );
                  }, childCount: group.comments.length),
                ),
              ),
            ],
          );
        }),
        SliverToBoxAdapter(child: SizedBox(height: 16)),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context, CommentsState state) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverShimmeringList(spacing: 16, maxHeight: 100),
        ),
      ],
    );
  }

  String _getCommentCountText(int count) {
    return pluralizeRu(
      count,
      '$count комментарий',
      '$count комментария',
      '$count комментариев',
    );
  }

  void _scrollToParentComment(CommentsState state, int? parentId) {
    if (parentId == null) return;

    // Find the parent comment's group
    final parentGroupIndex = state.groupedComments.indexWhere(
      (group) => group.comments.any((c) => c.id == parentId),
    );

    if (parentGroupIndex == -1) return;

    // Calculate approximate scroll position
    // This is a simple implementation - could be improved with better positioning
    double position = 0;
    for (int i = 0; i < parentGroupIndex; i++) {
      // Approximate height: date header (48) + comments (125 each)
      position += 48 + (state.groupedComments[i].comments.length * 125);
    }

    _scrollController.animateTo(
      position,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
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
}
