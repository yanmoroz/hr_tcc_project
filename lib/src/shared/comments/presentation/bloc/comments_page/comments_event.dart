import 'package:freezed_annotation/freezed_annotation.dart';

part 'comments_event.freezed.dart';

@freezed
class CommentsEvent with _$CommentsEvent {
  const factory CommentsEvent.loadComments() = LoadComments;
  const factory CommentsEvent.refreshComments() = RefreshComments;
  const factory CommentsEvent.addComment({
    required String content,
    int? parentId,
  }) = AddComment;
  const factory CommentsEvent.deleteComment(int commentId) = DeleteComment;
  const factory CommentsEvent.toggleCommentLike(int commentId) = ToggleCommentLike;
}
