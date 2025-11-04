import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'comments_state.freezed.dart';

@freezed
class CommentsState with _$CommentsState {
  const factory CommentsState.initial() = CommentsInitial;
  const factory CommentsState.loading() = CommentsLoading;
  const factory CommentsState.loaded({
    required List<Comment> comments,
    @Default(false) bool isAddingComment,
  }) = CommentsLoaded;
  const factory CommentsState.error(String message) = CommentsError;
}
