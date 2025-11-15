import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/value_objects/application_status.dart';

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
