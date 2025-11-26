import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/base_types/loading_status.dart';
import '../../../../core/utils/pluralization.dart';
import '../blocs/comments_page/bloc.dart';
import '../widgets/comment_item.dart';
import '../widgets/date_separator.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({super.key});

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
            final commentCount = state.comments.length;
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
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.groupedComments.length,
                    itemBuilder: (context, index) {
                      final group = state.groupedComments[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date separator at the end (appears at top due to reverse)
                          DateSeparator(date: group.date),
                          // Comments for this day
                          ...group.comments.map(
                            (comment) => CommentItem(
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
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),

          _CommentInputBar(
            controller: _commentController,
            onSend: (content) {
              context.read<CommentsBloc>().add(
                CommentsEvent.addComment(content: content),
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

  String _getCommentCountText(int count) {
    return pluralizeRu(
      count,
      '$count комментарий',
      '$count комментария',
      '$count комментариев',
    );
  }
}

class _CommentInputBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSend;

  const _CommentInputBar({required this.controller, required this.onSend});

  @override
  State<_CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<_CommentInputBar> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsBloc, CommentsState>(
      buildWhen: (previous, current) =>
          previous.isAddingComment != current.isAddingComment,
      builder: (context, state) {
        final isAddingComment = state.isAddingComment;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
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
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(width: 12),
              // Attachment button
              IconButton(
                icon: SvgPicture.asset(
                  Assets.icons.attachmentIcon,
                  width: 28,
                  height: 28,
                ),
                onPressed: isAddingComment
                    ? null
                    : () {
                        // TODO: Implement attachment functionality
                      },
                style: IconButton.styleFrom(
                  fixedSize: const Size(28, 28),
                  minimumSize: const Size(28, 28),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                ),
              ),
              const SizedBox(width: 8),
              // Text field
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Ваш комментарий',
                    hintStyle: const TextStyle(
                      color: Color(0xFF767679),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    constraints: const BoxConstraints(minHeight: 32),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFBABABE),
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFBABABE),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFBABABE),
                        width: 1,
                      ),
                    ),
                  ),
                  minLines: 1,
                  maxLines: 5,
                  enabled: !isAddingComment,
                ),
              ),
              const SizedBox(width: 8),
              // Send button - only visible when focused
              if (_isFocused || isAddingComment) ...[
                IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFF0A3899),
                    fixedSize: const Size(32, 32),
                    minimumSize: const Size(32, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: isAddingComment
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: const Color(0xFF0A3899),
                          ),
                        )
                      : SvgPicture.asset(
                          Assets.icons.arrowUp,
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                          fit: BoxFit.none,
                        ),
                  onPressed: isAddingComment
                      ? null
                      : () {
                          final content = widget.controller.text.trim();
                          if (content.isNotEmpty) {
                            widget.onSend(content);
                            widget.controller.clear();
                          }
                        },
                ),
              ],
              const SizedBox(width: 12),
            ],
          ),
        );
      },
    );
  }
}
