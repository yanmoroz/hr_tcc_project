import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../users/users.dart';

part 'mention_state.freezed.dart';

@freezed
sealed class MentionState with _$MentionState {
  const factory MentionState({
    @Default(MentionStatus.idle) MentionStatus status,
    @Default([]) List<User> users,
    @Default('') String query,
    String? errorMessage,
  }) = _MentionState;
}

enum MentionStatus { idle, loading, success, error }
