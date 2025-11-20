import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/params/create_application_params.dart';

part 'application_form_event.freezed.dart';

@freezed
class ApplicationFormEvent with _$ApplicationFormEvent {
  const factory ApplicationFormEvent.submitForm(
    CreateApplicationParams params,
  ) = SubmitForm;

  const factory ApplicationFormEvent.resetForm() = ResetForm;
}
