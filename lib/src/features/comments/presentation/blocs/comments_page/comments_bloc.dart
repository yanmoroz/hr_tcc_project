import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/extensions/date_time_extension.dart';
import '../../../../../core/value_objects/system_type.dart';
import '../../../../../shared/files/domain/domain.dart';
import '../../../../../shared/files/presentation/models/uploading_attachment_state.dart';
import '../../../domain/domain.dart';
import 'comments_event.dart';
import 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  static const _imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'];
  final int entityId;
  final CommentableEntityType entityType;
  final String entityName;
  final GetCommentsUsecase _getCommentsUsecase;
  final AddCommentUsecase _addCommentUsecase;
  final DeleteCommentUsecase _deleteCommentUsecase;
  final ToggleCommentLikeUsecase _toggleCommentLikeUsecase;
  final UploadFileUsecase _uploadFileUsecase;

  final DownloadFileUsecase _downloadFileUsecase;

  final Set<String> _cancelledUploads = {};

  CommentsBloc({
    required this.entityId,
    required this.entityType,
    required this.entityName,
    required GetCommentsUsecase getCommentsUsecase,
    required AddCommentUsecase addCommentUsecase,
    required DeleteCommentUsecase deleteCommentUsecase,
    required ToggleCommentLikeUsecase toggleCommentLikeUsecase,
    required UploadFileUsecase uploadFileUsecase,
    required DownloadFileUsecase downloadFileUsecase,
  }) : _getCommentsUsecase = getCommentsUsecase,
       _addCommentUsecase = addCommentUsecase,
       _deleteCommentUsecase = deleteCommentUsecase,
       _toggleCommentLikeUsecase = toggleCommentLikeUsecase,
       _uploadFileUsecase = uploadFileUsecase,
       _downloadFileUsecase = downloadFileUsecase,
       super(const CommentsState()) {
    on<LoadComments>(_onLoadComments);
    on<RefreshComments>(_onRefreshComments);
    on<AddComment>(_onAddComment);
    on<DeleteComment>(_onDeleteComment);
    on<ToggleCommentLike>(_onToggleCommentLike);
    on<StartReply>(_onStartReply);
    on<CancelReply>(_onCancelReply);
    on<AddAttachments>(_onAddAttachments);
    on<RemoveAttachment>(_onRemoveAttachment);
    on<CancelAttachmentUpload>(_onCancelAttachmentUpload);
    on<FetchAttachment>(_onFetchAttachment);
    on<PreloadImageAttachments>(_onPreloadImageAttachments);
  }

  FileGroup get _fileGroup => entityType == CommentableEntityType.news
      ? FileGroup.news
      : FileGroup.discount;

  List<CommentDayGroup> _groupCommentsByDay(List<Comment> comments) {
    if (comments.isEmpty) return [];

    // Sort descending (newest first) for reversed ListView
    final sortedComments = List<Comment>.from(comments)
      ..sort((a, b) => b.createdData.compareTo(a.createdData));

    final List<CommentDayGroup> groups = [];
    DateTime? currentDate;
    List<Comment> currentGroup = [];

    for (final comment in sortedComments) {
      final commentDate = DateTime(
        comment.createdData.year,
        comment.createdData.month,
        comment.createdData.day,
      );

      if (currentDate == null || !currentDate.isSameDay(commentDate)) {
        // Save previous group if exists
        if (currentGroup.isNotEmpty && currentDate != null) {
          groups.add(
            CommentDayGroup(date: currentDate, comments: currentGroup),
          );
        }
        // Start new group
        currentDate = commentDate;
        currentGroup = [comment];
      } else {
        currentGroup.insert(0, comment);
      }
    }

    // Add last group
    if (currentGroup.isNotEmpty && currentDate != null) {
      groups.add(CommentDayGroup(date: currentDate, comments: currentGroup));
    }

    return groups;
  }

  bool _isImageAttachment(Attachment attachment) {
    return _imageExtensions.contains(attachment.extension.toLowerCase()) ||
        attachment.thumbnail != null;
  }

  Future<void> _loadComments(Emitter<CommentsState> emit) async {
    final result = await _getCommentsUsecase(
      entityId: entityId,
      entityType: entityType,
    );

    result.fold(
      (error) => emit(
        state.copyWith(
          status: LoadingStatus.error,
          errorMessage: error.toString(),
        ),
      ),
      (comments) => emit(
        state.copyWith(
          status: LoadingStatus.success,
          comments: comments,
          groupedComments: _groupCommentsByDay(comments),
          isAddingComment: false,
        ),
      ),
    );
  }

  Future<void> _onAddAttachments(
    AddAttachments event,
    Emitter<CommentsState> emit,
  ) async {
    final baseTimestamp = DateTime.now().millisecondsSinceEpoch;
    final filesToUpload = <(String fileId, File file)>[];

    // First, add all files to state to show them in UI
    for (var i = 0; i < event.files.length; i++) {
      final file = event.files[i];
      final fileId = '${baseTimestamp}_$i';
      final fileName = file.path.split('/').last;

      filesToUpload.add((fileId, file));

      final uploadingFile = UploadingFile(
        id: fileId,
        fileName: fileName,
        file: file,
        state: const UploadingAttachmentState.loading(progress: 0),
      );

      emit(
        state.copyWith(
          uploadingFiles: [...state.uploadingFiles, uploadingFile],
        ),
      );
    }

    // Upload files one by one sequentially
    for (final (fileId, file) in filesToUpload) {
      await _startUpload(fileId, file);
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  Future<void> _onAddComment(
    AddComment event,
    Emitter<CommentsState> emit,
  ) async {
    // Only proceed if we're in success state and not already adding
    if (state.status != LoadingStatus.success || state.isAddingComment) {
      return;
    }

    // Get uploaded file IDs from successfully uploaded files
    final attachmentIds = state.uploadingFiles
        .where((f) => f.uploadedFileId != null)
        .map((f) => f.uploadedFileId!)
        .toList();

    emit(state.copyWith(isAddingComment: true));

    final result = await _addCommentUsecase(
      entityId: entityId,
      entityType: entityType,
      content: event.content,
      parent: event.parentId,
      attachments: attachmentIds.isNotEmpty ? attachmentIds : null,
    );

    result.fold(
      (error) {
        emit(state.copyWith(isAddingComment: false));
      },
      (_) {
        // Success - will reload comments below
      },
    );

    // Reload comments after successful add (outside fold to allow await)
    if (result.isRight()) {
      await _loadComments(emit);
      // Clear reply state and attachments after successful comment
      emit(state.copyWith(replyingToComment: null, uploadingFiles: []));
    }
  }

  void _onCancelAttachmentUpload(
    CancelAttachmentUpload event,
    Emitter<CommentsState> emit,
  ) {
    _cancelledUploads.add(event.fileId);
    final updatedFiles = state.uploadingFiles
        .where((f) => f.id != event.fileId)
        .toList();
    emit(state.copyWith(uploadingFiles: updatedFiles));
  }

  void _onCancelReply(CancelReply event, Emitter<CommentsState> emit) {
    emit(state.copyWith(replyingToComment: null));
  }

  Future<void> _onDeleteComment(
    DeleteComment event,
    Emitter<CommentsState> emit,
  ) async {
    final result = await _deleteCommentUsecase(
      entityId: entityId,
      entityType: entityType,
      commentId: event.commentId,
    );

    if (result.isRight()) {
      // Reload comments after successful delete
      await _loadComments(emit);
    } else {
      // Show error (could emit error state or keep current)
      result.fold((error) {
        // Error handling if needed
      }, (_) {});
    }
  }

  Future<void> _onFetchAttachment(
    FetchAttachment event,
    Emitter<CommentsState> emit,
  ) async {
    final attachment = event.attachment;

    emit(
      state.copyWith(
        downloadingAttachment: DownloadingAttachment(
          attachmentId: attachment.id,
          status: DownloadingAttachmentStatus.loading,
        ),
      ),
    );

    final result = await _downloadFileUsecase(
      systemType: SystemType.kp,
      download: false,
      uriFile: attachment.url,
      onProgress: (received, total) {
        if (total > 0) {
          // ignore: invalid_use_of_visible_for_testing_member
          emit(
            state.copyWith(
              downloadingAttachment: DownloadingAttachment(
                attachmentId: attachment.id,
                status: DownloadingAttachmentStatus.loading,
                progress: received / total,
              ),
            ),
          );
        }
      },
    );

    result.fold(
      (error) => emit(
        state.copyWith(
          downloadingAttachment: DownloadingAttachment(
            attachmentId: attachment.id,
            status: DownloadingAttachmentStatus.error,
            errorMessage: error.toString(),
          ),
        ),
      ),
      (data) => emit(
        state.copyWith(
          downloadingAttachment: DownloadingAttachment(
            attachmentId: attachment.id,
            status: DownloadingAttachmentStatus.success,
            data: data,
          ),
        ),
      ),
    );
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));
    await _loadComments(emit);
  }

  Future<void> _onPreloadImageAttachments(
    PreloadImageAttachments event,
    Emitter<CommentsState> emit,
  ) async {
    // Collect all image attachments from all comments
    final imageAttachments = <Attachment>[];
    for (final comment in state.comments) {
      final attachments = comment.attachments;
      if (attachments != null) {
        for (final attachment in attachments) {
          if (_isImageAttachment(attachment) &&
              !state.preloadedImages.containsKey(attachment.id)) {
            imageAttachments.add(attachment);
          }
        }
      }
    }

    // Preload each image in parallel
    for (final attachment in imageAttachments) {
      _preloadImage(attachment);
    }
  }

  Future<void> _onRefreshComments(
    RefreshComments event,
    Emitter<CommentsState> emit,
  ) async {
    await _loadComments(emit);
  }

  void _onRemoveAttachment(
    RemoveAttachment event,
    Emitter<CommentsState> emit,
  ) {
    final updatedFiles = state.uploadingFiles
        .where((f) => f.id != event.fileId)
        .toList();
    emit(state.copyWith(uploadingFiles: updatedFiles));
  }

  void _onStartReply(StartReply event, Emitter<CommentsState> emit) {
    emit(state.copyWith(replyingToComment: event.comment));
  }

  Future<void> _onToggleCommentLike(
    ToggleCommentLike event,
    Emitter<CommentsState> emit,
  ) async {
    // Optimistic update
    if (state.status == LoadingStatus.success) {
      final updatedComments = state.comments.map((comment) {
        if (comment.id == event.commentId) {
          final currentLike = comment.like ?? false;
          final currentLikeCount = comment.likeCount ?? 0;
          return comment.copyWith(
            like: !currentLike,
            likeCount: currentLike
                ? currentLikeCount - 1
                : currentLikeCount + 1,
          );
        }
        return comment;
      }).toList();

      emit(
        state.copyWith(
          comments: updatedComments,
          groupedComments: _groupCommentsByDay(updatedComments),
        ),
      );
    }

    // Make API call
    final result = await _toggleCommentLikeUsecase(
      entityId: entityId,
      entityType: entityType,
      commentId: event.commentId,
    );

    result.fold(
      (error) {
        // Revert on error
        if (state.status == LoadingStatus.success) {
          final revertedComments = state.comments.map((comment) {
            if (comment.id == event.commentId) {
              final currentLike = comment.like ?? false;
              final currentLikeCount = comment.likeCount ?? 0;
              return comment.copyWith(
                like: !currentLike,
                likeCount: currentLike
                    ? currentLikeCount - 1
                    : currentLikeCount + 1,
              );
            }
            return comment;
          }).toList();

          emit(
            state.copyWith(
              comments: revertedComments,
              groupedComments: _groupCommentsByDay(revertedComments),
            ),
          );
        }
      },
      (_) {
        // Success - state already updated optimistically
      },
    );
  }

  Future<void> _preloadImage(Attachment attachment) async {
    final result = await _downloadFileUsecase(
      systemType: SystemType.kp,
      download: false,
      uriFile: attachment.url,
    );

    result.fold(
      (_) {}, // Ignore errors for preloading
      (data) {
        final updatedCache = Map<int, Uint8List>.from(state.preloadedImages);
        updatedCache[attachment.id] = data;
        // ignore: invalid_use_of_visible_for_testing_member
        emit(state.copyWith(preloadedImages: updatedCache));
      },
    );
  }

  Future<void> _startUpload(String fileId, File file) async {
    final result = await _uploadFileUsecase(
      file: file,
      systemType: SystemType.kp,
      group: _fileGroup,
      onProgress: (sent, total) {
        if (_cancelledUploads.contains(fileId)) return;

        _updateFileProgress(fileId, sent / total);
      },
    );

    if (_cancelledUploads.contains(fileId)) {
      _cancelledUploads.remove(fileId);
      return;
    }

    result.fold((error) => _updateFileError(fileId, error.toString()), (
      uploadedFile,
    ) {
      final kpFile = uploadedFile.asKp;
      _updateFileSuccess(fileId, uploadedFile.size ?? 0, kpFile?.id);
    });
  }

  void _updateFileError(String fileId, String errorMessage) {
    final updatedFiles = state.uploadingFiles.map((f) {
      if (f.id == fileId) {
        return f.copyWith(
          state: UploadingAttachmentState.error(message: errorMessage),
        );
      }
      return f;
    }).toList();

    // ignore: invalid_use_of_visible_for_testing_member
    emit(state.copyWith(uploadingFiles: updatedFiles));
  }

  void _updateFileProgress(String fileId, double progress) {
    final updatedFiles = state.uploadingFiles.map((f) {
      if (f.id == fileId) {
        return f.copyWith(
          state: UploadingAttachmentState.loading(progress: progress),
        );
      }
      return f;
    }).toList();

    // ignore: invalid_use_of_visible_for_testing_member
    emit(state.copyWith(uploadingFiles: updatedFiles));
  }

  void _updateFileSuccess(String fileId, int fileSize, int? uploadedFileId) {
    final updatedFiles = state.uploadingFiles.map((f) {
      if (f.id == fileId) {
        return f.copyWith(
          state: UploadingAttachmentState.success(fileSize: fileSize),
          uploadedFileId: uploadedFileId,
        );
      }
      return f;
    }).toList();

    // ignore: invalid_use_of_visible_for_testing_member
    emit(state.copyWith(uploadingFiles: updatedFiles));
  }
}
