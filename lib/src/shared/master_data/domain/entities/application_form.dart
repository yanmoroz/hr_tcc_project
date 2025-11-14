import 'package:freezed_annotation/freezed_annotation.dart';

part 'application_form.freezed.dart';

@freezed
abstract class ApplicationForm with _$ApplicationForm {
  const factory ApplicationForm({
    required String id,
    required String idGroup,
    required String code,
    String? codeSystem,
    String? system,
    required String name,
    required bool archive,
  }) = _ApplicationForm;
}
