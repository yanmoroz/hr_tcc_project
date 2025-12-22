import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/base_types/result.dart';
import '../../../../../core/theme/theme.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../../../../core/widgets/user_avatar.dart';
import '../../domain/domain.dart';
import 'comment_action_bar.dart';
import 'comment_attachment_item.dart';
import 'comment_reply_indicator.dart';
import 'mention_rich_text.dart';

class CommentItem extends StatefulWidget {
  // TODO: Replace with actual current user ID from auth
  static const int _currentUserId = 20370;
  final Comment comment;
  final String? parentAuthorName;
  final String? parentComment;
  final VoidCallback onLike;
  final VoidCallback? onDelete;
  final VoidCallback? onReply;
  final VoidCallback? onParentTap;

  /// Called when a mention is tapped. The mention name (without "@") is passed.
  final void Function(String mentionName)? onMentionTap;

  /// Called when an attachment is tapped.
  final void Function(Attachment attachment)? onAttachmentTap;

  /// Preloaded image data for attachments, keyed by attachment ID.
  final Map<int, Uint8List> preloadedImages;

  final bool isLastInGroup;

  const CommentItem({
    super.key,
    required this.comment,
    this.parentAuthorName,
    this.parentComment,
    required this.onLike,
    this.onDelete,
    this.onReply,
    this.onParentTap,
    this.onMentionTap,
    this.onAttachmentTap,
    this.preloadedImages = const {},
    this.isLastInGroup = false,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  Future<Result<Uint8List>>? _photoFuture;

  bool get _isCurrentUser =>
      widget.comment.author.id == CommentItem._currentUserId;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.isLastInGroup ? 0 : 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: _isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!_isCurrentUser) ...[_buildAvatar(), const SizedBox(width: 12)],
          _buildBubble(context),
          if (_isCurrentUser) ...[const SizedBox(width: 12), _buildAvatar()],
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _photoFuture = createUserPhotoFuture(
      systemType: SystemType.kp,
      photoExists: widget.comment.author.photo.isNotEmpty,
      userId: widget.comment.author.id.toString(),
      uriFile: widget.comment.author.photo,
    );
  }

  Widget _buildAttachments() {
    final attachments = widget.comment.attachments;
    if (attachments == null || attachments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        height: 85,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: attachments.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final attachment = attachments[index];
            return CommentAttachmentItem(
              attachment: attachment,
              imageData: widget.preloadedImages[attachment.id],
              onTap: widget.onAttachmentTap != null
                  ? () => widget.onAttachmentTap!(attachment)
                  : null,
            );
          },
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return UserAvatar.fromFullName(
      fullName: widget.comment.author.title,
      radius: 16,
      photoFuture: _photoFuture,
    );
  }

  Widget _buildBubble(BuildContext context) {
    return Flexible(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 150,
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReplyIndicator(),
              _buildHeader(),
              _buildAttachments(),
              const SizedBox(height: 4),
              MentionRichText(
                content: widget.comment.content,
                onMentionTap: widget.onMentionTap,
              ),
              const SizedBox(height: 12),
              CommentActionBar(
                isLiked: widget.comment.like ?? false,
                likeCount: widget.comment.likeCount ?? 0,
                onLike: widget.onLike,
                onDelete: widget.onDelete,
                onReply: widget.onReply,
                isCurrentUser: _isCurrentUser,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            widget.comment.author.title,
            style: AppTypography.textSemibold2.black,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatTime(widget.comment.createdData),
          style: AppTypography.captionMedium3.grey500,
        ),
      ],
    );
  }

  Widget _buildReplyIndicator() {
    if (widget.parentAuthorName == null ||
        widget.parentComment == null ||
        widget.onParentTap == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CommentReplyIndicator(
        authorName: widget.parentAuthorName!,
        comment: widget.parentComment!,
        onTap: widget.onParentTap!,
      ),
    );
  }

  String _formatTime(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }
}
