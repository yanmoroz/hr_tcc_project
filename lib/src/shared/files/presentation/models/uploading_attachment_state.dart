import 'package:freezed_annotation/freezed_annotation.dart';

part 'uploading_attachment_state.freezed.dart';

@freezed
sealed class UploadingAttachmentState with _$UploadingAttachmentState {
  const factory UploadingAttachmentState.loading({
    required double progress,
  }) = UploadingAttachmentLoading;

  const factory UploadingAttachmentState.success({
    required int fileSize,
  }) = UploadingAttachmentSuccess;

  const factory UploadingAttachmentState.error({
    String? message,
  }) = UploadingAttachmentError;
}
