import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_form_state.freezed.dart';

@freezed
class ApplicationFormState with _$ApplicationFormState {
  const factory ApplicationFormState.initial() = ApplicationFormInitial;

  const factory ApplicationFormState.loadingData() =
      ApplicationFormLoadingData;

  const factory ApplicationFormState.dataLoaded(
    String formCode,
    Object? data,
  ) = ApplicationFormDataLoaded;

  const factory ApplicationFormState.submitting() = ApplicationFormSubmitting;

  const factory ApplicationFormState.success() = ApplicationFormSuccess;

  const factory ApplicationFormState.error(String message) =
      ApplicationFormError;
}
