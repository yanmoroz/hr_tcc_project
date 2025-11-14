import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/domain/value_objects/status_group_type.dart';
import '../../../domain/domain.dart';

part 'system_status_group_model.freezed.dart';
part 'system_status_group_model.g.dart';

@freezed
abstract class SystemStatusGroupModel with _$SystemStatusGroupModel {
  const factory SystemStatusGroupModel({
    @JsonKey(fromJson: statusGroupTypeFromJson)
    required StatusGroupType statusGroup,
    required String name,
  }) = _SystemStatusGroupModel;

  factory SystemStatusGroupModel.fromJson(Map<String, dynamic> json) =>
      _$SystemStatusGroupModelFromJson(json);
}

extension SystemStatusGroupModelX on SystemStatusGroupModel {
  SystemStatusGroup toDomain() {
    return SystemStatusGroup(statusGroup: statusGroup, name: name);
  }
}
