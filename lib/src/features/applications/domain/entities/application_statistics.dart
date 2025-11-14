import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/value_objects/status_group_type.dart';

part 'application_statistics.freezed.dart';

@freezed
abstract class ApplicationStatistics with _$ApplicationStatistics {
  const factory ApplicationStatistics({
    required StatusGroupType statusGroup,
    required String statusGroupName,
    required int count,
  }) = _ApplicationStatistics;
}
