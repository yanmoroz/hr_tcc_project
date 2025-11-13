import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hr_tcc_project/src/shared/master_data/domain/domain.dart';

part 'application_statistics.freezed.dart';

@freezed
abstract class ApplicationStatistics with _$ApplicationStatistics {
  const factory ApplicationStatistics({
    required StatusGroupType statusGroup,
    required String statusGroupName,
    required int count,
  }) = _ApplicationStatistics;
}
