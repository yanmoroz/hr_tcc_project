import 'package:freezed_annotation/freezed_annotation.dart';

import 'status_group_type.dart';

part 'system_status.freezed.dart';

@freezed
abstract class SystemStatus with _$SystemStatus {
  const factory SystemStatus({
    required String id,
    required String idForm,
    required StatusGroupType statusGroup,
    required String code,
    required String name,
    required bool cancelable,
  }) = _SystemStatus;
}
