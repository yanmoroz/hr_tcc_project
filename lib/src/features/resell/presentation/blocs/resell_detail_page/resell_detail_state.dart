import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/domain.dart';

part 'resell_detail_state.freezed.dart';

@freezed
sealed class ResellDetailState with _$ResellDetailState {
  const factory ResellDetailState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    ResellDetail? detail,
    @Default(false) bool isBooking,
    String? errorMessage,
  }) = _ResellDetailState;
}
