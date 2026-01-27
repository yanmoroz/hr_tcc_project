import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'polls_list_state.freezed.dart';

@freezed
sealed class PollsListState with _$PollsListState {
  const factory PollsListState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(LoadingStatus.initial) LoadingStatus filteringStatus,
    @Default([]) List<Poll> polls,
    @Default(0) int currentPage,
    @Default(true) bool hasMorePages,
    @Default(false) bool isLoadingMore,
    int? currentStatus, // null = "Все", 1 = "Непройденные", 2 = "Пройденные"
    @Default(0) int totalAll,
    @Default(0) int totalNotPassed,
    @Default(0) int totalPassed,
    String? errorMessage,
    @Default({}) Map<int, Uint8List> coverImages,
  }) = _PollsListState;
}
