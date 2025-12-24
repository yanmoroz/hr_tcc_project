import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';

part 'resell_booking_state.freezed.dart';

@freezed
sealed class ResellBookingState with _$ResellBookingState {
  const factory ResellBookingState({
    required String itemId,
    required String itemName,
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default(false) bool isConfirming,
    String? errorMessage,
  }) = _ResellBookingState;
}
