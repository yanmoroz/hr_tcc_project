import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
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
  }) = _CommentsState;
}
