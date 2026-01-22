import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/uploading_attachment/uploading_attachment.dart';
import '../../../../core/widgets/uploading_attachment/uploading_attachment_state.dart';
import '../../domain/domain.dart';
import '../blocs/comments_page/comments_state.dart';

/// Callback with two parameters: content and optional parent comment ID.
typedef OnSendComment = void Function(String content, int? parentId);

class CommentInputBar extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final OnSendComment onSend;
  final VoidCallback onCancelReply;
  final bool isAddingComment;
  final Comment? replyingToComment;
  final List<UploadingFile> uploadingFiles;
  final VoidCallback onAttachmentTap;
  final void Function(String fileId) onRemoveFile;
  final void Function(String fileId) onCancelUpload;

  const CommentInputBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onSend,
    required this.onCancelReply,
    this.isAddingComment = false,
    this.replyingToComment,
    this.uploadingFiles = const [],
    required this.onAttachmentTap,
    required this.onRemoveFile,
    required this.onCancelUpload,
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
          if (widget.uploadingFiles.isNotEmpty) _buildAttachmentsRow(),
          _buildInputRow(),
        ],
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

  Widget _buildAttachmentsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: SizedBox(
        height: 104,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: widget.uploadingFiles.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final file = widget.uploadingFiles[index];
            final isLoading = file.state is UploadingAttachmentLoading;
            return UploadingAttachment(
              fileName: file.fileName,
              state: file.state,
              imageFile: file.file,
              displayFileName: false,
              onCancel: isLoading ? () => widget.onCancelUpload(file.id) : null,
              onDelete: () => widget.onRemoveFile(file.id),
            );
          },
        ),
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
            onTap: widget.onAttachmentTap,
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
          colorFilter: const ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
      ),
    );
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
