import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/entities/application_form.dart';
import '../../../../../core/entities/application_form_group.dart';

part 'application_creation_state.freezed.dart';

@freezed
class ApplicationCreationState with _$ApplicationCreationState {
  const factory ApplicationCreationState.initial() = ApplicationCreationInitial;

  const factory ApplicationCreationState.loading() = ApplicationCreationLoading;

  const factory ApplicationCreationState.loaded({
    required List<ApplicationForm> allForms,
    required List<ApplicationFormGroup> groups,
    required List<ApplicationForm> filteredForms,
    String? selectedGroupId,
    String? searchQuery,
  }) = ApplicationCreationLoaded;

  const factory ApplicationCreationState.error(String message) =
      ApplicationCreationError;
}
