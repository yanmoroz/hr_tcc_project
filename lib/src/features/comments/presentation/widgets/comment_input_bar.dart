import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/theme.dart';
import '../blocs/comments_page/bloc.dart';

// Helper typedef for ValueChanged with two parameters
typedef ValueChanged2<T1, T2> = void Function(T1, T2);

class CommentInputBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged2<String, int?> onSend;

  const CommentInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
  });

  @override
  State<CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<CommentInputBar> {
  bool _isFocused = false;
  bool _hasText = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsBloc, CommentsState>(
      buildWhen: (previous, current) =>
          previous.isAddingComment != current.isAddingComment ||
          previous.replyingToComment != current.replyingToComment,
      builder: (context, state) {
        final isAddingComment = state.isAddingComment;
        final replyingToComment = state.replyingToComment;
        final isReplyMode = replyingToComment != null;

        return Container(
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow.withValues(alpha: 0.05),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Reply mode header
              if (isReplyMode) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Reply arrow icon
                      SvgPicture.asset(Assets.icons.replyIcon),
                      const SizedBox(width: 8),
                      // Vertical separator line
                      Container(width: 2, height: 40, color: AppColors.blue700),
                      const SizedBox(width: 8),
                      // Reply info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'В ответ ${replyingToComment.author.title}',
                              style: AppTypography.textSemibold2.black,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              replyingToComment.content,
                              style: AppTypography.textRegular2.black,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Cancel button
                      InkWell(
                        onTap: () {
                          context.read<CommentsBloc>().add(
                            const CommentsEvent.cancelReply(),
                          );
                          widget.controller.clear();
                        },
                        child: SvgPicture.asset(
                          Assets.icons.closeIcon,
                          colorFilter: const ColorFilter.mode(
                            AppColors.blue700,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              // Input row
              Padding(
                padding: EdgeInsets.fromLTRB(0, isReplyMode ? 8 : 16, 0, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(width: 12),
                    InkWell(
                      onTap: () {
                        // TODO: Implement attachment functionality
                      },
                      child: SvgPicture.asset(Assets.icons.attachmentIcon),
                    ),
                    const SizedBox(width: 8),
                    // Text field
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        style: AppTypography.textRegular1.black,
                        decoration: InputDecoration(
                          hintText: isReplyMode
                              ? 'Ваш ответ'
                              : 'Ваш комментарий',
                          hintStyle: AppTypography.textRegular1.grey700,
                          isDense: true,
                          filled: true,
                          fillColor: AppColors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.grey500,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.grey500,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.grey500,
                              width: 1,
                            ),
                          ),
                        ),
                        minLines: 1,
                        maxLines: 8,
                        enabled: !isAddingComment,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Send button - visible when focused or in reply mode, and has text
                    if (_isFocused && _hasText)
                      InkWell(
                        onTap: isAddingComment
                            ? null
                            : () {
                                final content = widget.controller.text.trim();
                                if (content.isNotEmpty) {
                                  widget.onSend(content, replyingToComment?.id);
                                  widget.controller.clear();
                                  if (isReplyMode) {
                                    context.read<CommentsBloc>().add(
                                      const CommentsEvent.cancelReply(),
                                    );
                                  }
                                }
                              },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.blue700,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.all(4),
                          child: SvgPicture.asset(
                            Assets.icons.arrowUp,
                            colorFilter: const ColorFilter.mode(
                              AppColors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChange);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
    _hasText = widget.controller.text.trim().isNotEmpty;
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = widget.focusNode.hasFocus;
    });
  }

  void _onTextChange() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (_hasText != hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }
}
