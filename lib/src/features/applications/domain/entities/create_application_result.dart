import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_tcc_project/src/shared/types/types.dart';

part 'create_application_result.freezed.dart';

@freezed
abstract class CreateApplicationResult with _$CreateApplicationResult {
  const factory CreateApplicationResult({
    required ApplicationStatus status,
    String? instance,
    String? id,
    String? idApplication,
  }) = _CreateApplicationResult;
}
