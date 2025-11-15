import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/entities/application_form.dart';
import '../../../../core/domain/entities/system_status.dart';

part 'application_info.freezed.dart';

@freezed
abstract class ApplicationInfo with _$ApplicationInfo {
  const factory ApplicationInfo({
    required String id,
    required String idApplication,
    required String name,
    required ApplicationForm applicationForm,
    required String iniciator,
    required SystemStatus systemStatus,
    required DateTime applicationDate,
    required DateTime createDate,
  }) = _ApplicationInfo;
}
