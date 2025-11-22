import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../domain/entities/application_detail.dart';

part 'application_detail_state.freezed.dart';

@freezed
sealed class ApplicationDetailState with _$ApplicationDetailState {
  const factory ApplicationDetailState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    ApplicationDetail? detail,
    @Default(false) bool isCanceling,
    String? errorMessage,
  }) = _ApplicationDetailState;
}
