import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'comments_state.freezed.dart';


class CommentDayGroup {
  final DateTime date;
  final List<Comment> comments;

  const CommentDayGroup({required this.date, required this.comments});
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
