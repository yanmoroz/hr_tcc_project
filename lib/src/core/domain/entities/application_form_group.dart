import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_form_group.freezed.dart';

@freezed
abstract class ApplicationFormGroup with _$ApplicationFormGroup {
  const factory ApplicationFormGroup({
    required String id,
    required int code,
    required String name,
  }) = _ApplicationFormGroup;
}
