import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/value_objects/status_group_type.dart';

part 'system_status_group.freezed.dart';

@freezed
abstract class SystemStatusGroup with _$SystemStatusGroup {
  const factory SystemStatusGroup({
    required StatusGroupType statusGroup,
    required String name,
  }) = _SystemStatusGroup;
}
