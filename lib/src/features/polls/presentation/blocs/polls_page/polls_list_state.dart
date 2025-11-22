import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'polls_list_state.freezed.dart';

@freezed
sealed class PollsListState with _$PollsListState {
  const factory PollsListState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<Poll> polls,
    @Default({}) Map<int, Uint8List> coverImages,
    String? errorMessage,
  }) = _PollsListState;
}
