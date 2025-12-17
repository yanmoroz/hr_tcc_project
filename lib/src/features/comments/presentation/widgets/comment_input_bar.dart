import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/domain.dart';

/// Callback with two parameters: content and optional parent comment ID.
typedef OnSendComment = void Function(String content, int? parentId);

class CommentInputBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final OnSendComment onSend;
  final VoidCallback onCancelReply;
  final bool isAddingComment;
  final Comment? replyingToComment;

  const CommentInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onCancelReply,
    this.isAddingComment = false,
    this.replyingToComment,
  });

  @override
  State<CommentInputBar> createState() => _CommentInputBarState();
}

class _CommentInputBarState extends State<CommentInputBar> {
  static final _inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppColors.grey500, width: 1),
  );

  bool _isFocused = false;
  bool _hasText = false;

  bool get _isReplyMode => widget.replyingToComment != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.replyingToComment != null)
            _buildReplyHeader(widget.replyingToComment!),
          _buildInputRow(),
        ],
      ),
    );
  }

  Widget _buildReplyHeader(Comment replyingTo) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(Assets.icons.replyIcon),
          const SizedBox(width: 8),
          Container(width: 2, height: 40, color: AppColors.blue700),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'В ответ ${replyingTo.author.title}',
                  style: AppTypography.textSemibold2.black,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  replyingTo.content,
                  style: AppTypography.textRegular2.black,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              widget.onCancelReply();
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
    );
  }

  Widget _buildInputRow() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, _isReplyMode ? 8 : 16, 0, 16),
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
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              style: AppTypography.textRegular1.black,
              decoration: InputDecoration(
                hintText: _isReplyMode ? 'Ваш ответ' : 'Ваш комментарий',
                hintStyle: AppTypography.textRegular1.grey700,
                isDense: true,
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                border: _inputBorder,
                enabledBorder: _inputBorder,
                focusedBorder: _inputBorder,
              ),
              minLines: 1,
              maxLines: 8,
              enabled: !widget.isAddingComment,
            ),
          ),
          const SizedBox(width: 8),
          _buildSendButton(),
          const SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    if (!_isFocused || !_hasText) {
      return const SizedBox.shrink();
    }

    return InkWell(
      onTap: widget.isAddingComment
          ? null
          : () {
              final content = widget.controller.text.trim();
              if (content.isNotEmpty) {
                widget.onSend(content, widget.replyingToComment?.id);
                widget.controller.clear();
                if (_isReplyMode) {
                  widget.onCancelReply();
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
        padding: const EdgeInsets.all(4),
        child: SvgPicture.asset(
          Assets.icons.arrowUp,
          colorFilter: const ColorFilter.mode(
            AppColors.white,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(CommentInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      oldWidget.focusNode.removeListener(_onFocusChange);
      widget.focusNode.addListener(_onFocusChange);
    }
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTextChange);
      widget.controller.addListener(_onTextChange);
      _hasText = widget.controller.text.trim().isNotEmpty;
    }
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
