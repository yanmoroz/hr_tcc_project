import 'dart:io';
import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/widgets/uploading_attachment/uploading_attachment_state.dart';
import '../../../domain/domain.dart';

part 'comments_state.freezed.dart';

@freezed
sealed class CommentDayGroup with _$CommentDayGroup {
  const factory CommentDayGroup({
    required DateTime date,
    required List<Comment> comments,
  }) = _CommentDayGroup;
}

@freezed
sealed class CommentsState with _$CommentsState {
  const factory CommentsState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<Comment> comments,
    @Default([]) List<CommentDayGroup> groupedComments,
    @Default(false) bool isAddingComment,
    Comment? replyingToComment,
    String? errorMessage,
    @Default([]) List<UploadingFile> uploadingFiles,
    DownloadingAttachment? downloadingAttachment,
    @Default({}) Map<int, Uint8List> preloadedImages,
  }) = _CommentsState;
}

@freezed
sealed class DownloadingAttachment with _$DownloadingAttachment {
  const factory DownloadingAttachment({
    required int attachmentId,
    required DownloadingAttachmentStatus status,
    @Default(0) double progress,
    Uint8List? data,
    String? errorMessage,
  }) = _DownloadingAttachment;
}

enum DownloadingAttachmentStatus { loading, success, error }

@freezed
sealed class UploadingFile with _$UploadingFile {
  const factory UploadingFile({
    required String id,
    required String fileName,
    required File file,
    required UploadingAttachmentState state,
    int? uploadedFileId,
  }) = _UploadingFile;
}
