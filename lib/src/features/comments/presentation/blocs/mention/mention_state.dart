import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../g2g/users/users.dart';

part 'mention_state.freezed.dart';

enum MentionStatus { idle, loading, success, error }

@freezed
sealed class MentionState with _$MentionState {
  const factory MentionState({
    @Default(MentionStatus.idle) MentionStatus status,
    @Default([]) List<User> users,
    @Default('') String query,
    String? errorMessage,
  }) = _MentionState;
}
