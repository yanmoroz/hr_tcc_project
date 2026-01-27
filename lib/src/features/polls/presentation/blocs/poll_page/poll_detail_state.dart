import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'poll_detail_state.freezed.dart';

@freezed
sealed class PollDetailState with _$PollDetailState {
  const factory PollDetailState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    PollDetail? pollDetail,
    @Default(0) int currentPageIndex,
    @Default(false) bool isSearchingStaff,
    @Default(false) bool isSubmitting,
    List<StaffItem>? staffItems,
    String? staffSearchError,
    String? errorMessage,
    Uint8List? coverImage,
  }) = _PollDetailState;
}
