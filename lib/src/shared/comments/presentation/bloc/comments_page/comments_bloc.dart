import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/types/result.dart';
import '../../../domain/domain.dart';
import 'comments_event.dart';
import 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final int entityId;
  final GetCommentsUsecase _getCommentsUsecase;
  final AddCommentUsecase _addCommentUsecase;
  final DeleteCommentUsecase _deleteCommentUsecase;
  final ToggleCommentLikeUsecase _toggleCommentLikeUsecase;

  CommentsBloc({
    required this.entityId,
    required GetCommentsUsecase getCommentsUsecase,
    required AddCommentUsecase addCommentUsecase,
    required DeleteCommentUsecase deleteCommentUsecase,
    required ToggleCommentLikeUsecase toggleCommentLikeUsecase,
  }) : _getCommentsUsecase = getCommentsUsecase,
       _addCommentUsecase = addCommentUsecase,
       _deleteCommentUsecase = deleteCommentUsecase,
       _toggleCommentLikeUsecase = toggleCommentLikeUsecase,
       super(const CommentsState.initial()) {
    on<LoadComments>(_onLoadComments);
    on<RefreshComments>(_onRefreshComments);
    on<AddComment>(_onAddComment);
    on<DeleteComment>(_onDeleteComment);
    on<ToggleCommentLike>(_onToggleCommentLike);
  }

  Future<void> _onLoadComments(LoadComments event, Emitter<CommentsState> emit) async {
    emit(const CommentsState.loading());
    await _loadComments(emit);
  }

  Future<void> _onRefreshComments(RefreshComments event, Emitter<CommentsState> emit) async {
    await _loadComments(emit);
  }

  Future<void> _onAddComment(AddComment event, Emitter<CommentsState> emit) async {
    // Extract state values first
    List<Comment>? comments;
    bool? isAddingComment;

    state.maybeWhen(
      loaded: (loadedComments, loadedIsAddingComment) {
        comments = loadedComments;
        isAddingComment = loadedIsAddingComment;
      },
      orElse: () {},
    );

    // Only proceed if we're in loaded state and not already adding
    if (comments != null && !(isAddingComment ?? false)) {
      emit(CommentsState.loaded(comments: comments!, isAddingComment: true));

      final result = await _addCommentUsecase(entityId: entityId, content: event.content, parent: event.parentId);

      result.fold(
        (error) {
          emit(CommentsState.loaded(comments: comments!, isAddingComment: false));
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
  }

  Future<void> _onDeleteComment(DeleteComment event, Emitter<CommentsState> emit) async {
    final result = await _deleteCommentUsecase(entityId: entityId, commentId: event.commentId);

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

  Future<void> _onToggleCommentLike(ToggleCommentLike event, Emitter<CommentsState> emit) async {
    // Optimistic update
    state.maybeWhen(
      loaded: (comments, isAddingComment) {
        final updatedComments = comments.map((comment) {
          if (comment.id == event.commentId) {
            final currentLike = comment.like ?? false;
            final currentLikeCount = comment.likeCount ?? 0;
            return comment.copyWith(
              like: !currentLike,
              likeCount: currentLike ? currentLikeCount - 1 : currentLikeCount + 1,
            );
          }
          return comment;
        }).toList();

        emit(CommentsState.loaded(comments: updatedComments, isAddingComment: isAddingComment));
      },
      orElse: () {},
    );

    // Make API call
    final result = await _toggleCommentLikeUsecase(entityId: entityId, commentId: event.commentId);

    result.fold(
      (error) {
        // Revert on error
        state.maybeWhen(
          loaded: (comments, isAddingComment) {
            final revertedComments = comments.map((comment) {
              if (comment.id == event.commentId) {
                final currentLike = comment.like ?? false;
                final currentLikeCount = comment.likeCount ?? 0;
                return comment.copyWith(
                  like: !currentLike,
                  likeCount: currentLike ? currentLikeCount - 1 : currentLikeCount + 1,
                );
              }
              return comment;
            }).toList();

            emit(CommentsState.loaded(comments: revertedComments, isAddingComment: isAddingComment));
          },
          orElse: () {},
        );
      },
      (_) {
        // Success - state already updated optimistically
      },
    );
  }

  Future<void> _loadComments(Emitter<CommentsState> emit) async {
    final result = await _getCommentsUsecase(entityId);

    result.fold(
      (error) => emit(CommentsState.error(error.message)),
      (comments) => emit(CommentsState.loaded(comments: comments)),
    );
  }
}
