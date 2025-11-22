import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'comments_state.freezed.dart';

@freezed
sealed class CommentsState with _$CommentsState {
  const factory CommentsState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<Comment> comments,
    @Default(false) bool isAddingComment,
    String? errorMessage,
  }) = _CommentsState;
}
