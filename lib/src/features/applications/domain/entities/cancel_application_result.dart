import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_tcc_project/src/shared/types/types.dart';

import '../../../../core/domain/entities/system_status.dart';

part 'cancel_application_result.freezed.dart';

@freezed
abstract class CancelApplicationResult with _$CancelApplicationResult {
  const factory CancelApplicationResult({
    required ApplicationStatus status,
    required String id,
    required SystemStatus systemStatus,
  }) = _CancelApplicationResult;
}
