import 'dart:io';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'comments_event.freezed.dart';

@freezed
class CommentsEvent with _$CommentsEvent {
  const factory CommentsEvent.addAttachments(List<File> files) = AddAttachments;
  const factory CommentsEvent.addComment({
    required String content,
    int? parentId,
  }) = AddComment;
  const factory CommentsEvent.cancelAttachmentUpload(String fileId) =
      CancelAttachmentUpload;
  const factory CommentsEvent.cancelReply() = CancelReply;
  const factory CommentsEvent.deleteComment(int commentId) = DeleteComment;
  const factory CommentsEvent.fetchAttachment(Attachment attachment) =
      FetchAttachment;
  const factory CommentsEvent.imagePreloaded({
    required int attachmentId,
    required Uint8List data,
  }) = ImagePreloaded;
  const factory CommentsEvent.loadComments() = LoadComments;
  const factory CommentsEvent.preloadImageAttachments() = PreloadImageAttachments;
  const factory CommentsEvent.refreshComments() = RefreshComments;
  const factory CommentsEvent.removeAttachment(String fileId) =
      RemoveAttachment;
  const factory CommentsEvent.startReply(Comment comment) = StartReply;
  const factory CommentsEvent.toggleCommentLike(int commentId) =
      ToggleCommentLike;
}
