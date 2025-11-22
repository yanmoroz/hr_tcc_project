import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/base_types/loading_status.dart';
import '../../../../../core/entities/application_form.dart';
import '../../../../../core/entities/application_form_group.dart';

part 'application_creation_state.freezed.dart';

@freezed
sealed class ApplicationCreationState with _$ApplicationCreationState {
  const factory ApplicationCreationState({
    @Default(LoadingStatus.initial) LoadingStatus status,
    @Default([]) List<ApplicationForm> allForms,
    @Default([]) List<ApplicationFormGroup> groups,
    @Default([]) List<ApplicationForm> filteredForms,
    String? selectedGroupId,
    String? searchQuery,
    String? errorMessage,
  }) = _ApplicationCreationState;
}
