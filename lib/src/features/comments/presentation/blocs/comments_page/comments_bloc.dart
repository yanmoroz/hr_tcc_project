import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/base_types/result.dart';
import '../../../domain/domain.dart';

import 'comments_event.dart';
import 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final int entityId;
  final CommentableEntityType entityType;
  final GetCommentsUsecase _getCommentsUsecase;
  final AddCommentUsecase _addCommentUsecase;
  final DeleteCommentUsecase _deleteCommentUsecase;
  final ToggleCommentLikeUsecase _toggleCommentLikeUsecase;

  CommentsBloc({
    required this.entityId,
    required this.entityType,
    required GetCommentsUsecase getCommentsUsecase,
    required AddCommentUsecase addCommentUsecase,
    required DeleteCommentUsecase deleteCommentUsecase,
    required ToggleCommentLikeUsecase toggleCommentLikeUsecase,
  }) : _getCommentsUsecase = getCommentsUsecase,
       _addCommentUsecase = addCommentUsecase,
       _deleteCommentUsecase = deleteCommentUsecase,
       _toggleCommentLikeUsecase = toggleCommentLikeUsecase,
       super(const CommentsState()) {
    on<LoadComments>(_onLoadComments);
    on<RefreshComments>(_onRefreshComments);
    on<AddComment>(_onAddComment);
    on<DeleteComment>(_onDeleteComment);
    on<ToggleCommentLike>(_onToggleCommentLike);
  }

  Future<void> _onLoadComments(
    LoadComments event,
    Emitter<CommentsState> emit,
  ) async {
    emit(state.copyWith(status: LoadingStatus.loading));
    await _loadComments(emit);
  }

  Future<void> _onRefreshComments(
    RefreshComments event,
    Emitter<CommentsState> emit,
  ) async {
    await _loadComments(emit);
  }

  Future<void> _onAddComment(
    AddComment event,
    Emitter<CommentsState> emit,
  ) async {
    // Only proceed if we're in success state and not already adding
    if (state.status != LoadingStatus.success || state.isAddingComment) {
      return;
    }

    emit(state.copyWith(isAddingComment: true));

    final result = await _addCommentUsecase(
      entityId: entityId,
      entityType: entityType,
      content: event.content,
      parent: event.parentId,
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
    }
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

      emit(state.copyWith(comments: updatedComments));
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

          emit(state.copyWith(comments: revertedComments));
        }
      },
      (_) {
        // Success - state already updated optimistically
      },
    );
  }

  Future<void> _loadComments(Emitter<CommentsState> emit) async {
    final result = await _getCommentsUsecase(
      entityId: entityId,
      entityType: entityType,
    );

    result.fold(
      (error) => emit(state.copyWith(
        status: LoadingStatus.error,
        errorMessage: error.message,
      )),
      (comments) => emit(state.copyWith(
        status: LoadingStatus.success,
        comments: comments,
        isAddingComment: false,
      )),
    );
  }
}
