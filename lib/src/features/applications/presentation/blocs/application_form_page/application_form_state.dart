import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';

part 'application_form_state.freezed.dart';

@freezed
sealed class ApplicationFormState with _$ApplicationFormState {
  const factory ApplicationFormState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    String? formCode,
    Object? data,
    @Default(false) bool isSubmitting,
    String? errorMessage,
  }) = _ApplicationFormState;
}
