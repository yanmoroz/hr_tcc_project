import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/value_objects/status_group_type.dart';
import '../../domain/domain.dart';

part 'application_statistics_model.freezed.dart';
part 'application_statistics_model.g.dart';

@freezed
abstract class ApplicationStatisticsModel with _$ApplicationStatisticsModel {
  const ApplicationStatisticsModel._();

  const factory ApplicationStatisticsModel({
    required String statusGroupCode,
    required String statusGroupName,
    required int count,
  }) = _ApplicationStatisticsModel;

  factory ApplicationStatisticsModel.fromJson(Map<String, dynamic> json) =>
      _$ApplicationStatisticsModelFromJson(json);

  ApplicationStatistics toDomain() => ApplicationStatistics(
    statusGroup: statusGroupTypeFromJson(statusGroupCode),
    statusGroupName: statusGroupName,
    count: count,
  );
}
