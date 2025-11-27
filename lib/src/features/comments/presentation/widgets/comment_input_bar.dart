import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../gen/assets.gen.dart';
import '../blocs/comments_page/bloc.dart';

// Helper typedef for ValueChanged with two parameters
typedef ValueChanged2<T1, T2> = void Function(T1, T2);

/// A reusable comment input bar widget that supports both message and reply modes.
///
/// This widget displays:
/// - Reply mode header (when replying to a comment)
/// - Text input field
/// - Attachment button
/// - Send button
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
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
    widget.controller.addListener(_onTextChange);
    _hasText = widget.controller.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    widget.controller.removeListener(_onTextChange);
    super.dispose();
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
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
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
                      SvgPicture.asset(
                        Assets.icons.replyIcon,
                        width: 28,
                        height: 28,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF0A3899),
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Vertical separator line
                      Container(
                        width: 2,
                        height: 40,
                        color: const Color(0xFF0A3899),
                      ),
                      const SizedBox(width: 8),
                      // Reply info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'В ответ ${replyingToComment.author.title}',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              replyingToComment.content,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: const Color(0xFF767679),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Cancel button
                      IconButton(
                        icon: SvgPicture.asset(
                          Assets.icons.crossIcon,
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF0A3899),
                            BlendMode.srcIn,
                          ),
                        ),
                        onPressed: () {
                          context.read<CommentsBloc>().add(
                            const CommentsEvent.cancelReply(),
                          );
                          widget.controller.clear();
                        },
                        style: IconButton.styleFrom(
                          fixedSize: const Size(24, 24),
                          minimumSize: const Size(24, 24),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          padding: EdgeInsets.zero,
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
                    // Attachment button - visible in both modes
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
                        focusNode: widget.focusNode,
                        style: const TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: isReplyMode
                              ? 'Ваш ответ'
                              : 'Ваш комментарий',
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
                    // Send button - visible when focused or in reply mode, and has text
                    if ((_isFocused || isReplyMode || isAddingComment) &&
                        _hasText)
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
                                  color: Color(0xFF0A3899),
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
                                  widget.onSend(content, replyingToComment?.id);
                                  widget.controller.clear();
                                  if (isReplyMode) {
                                    context.read<CommentsBloc>().add(
                                      const CommentsEvent.cancelReply(),
                                    );
                                  }
                                }
                              },
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
}
