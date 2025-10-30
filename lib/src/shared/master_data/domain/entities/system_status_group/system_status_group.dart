import 'package:freezed_annotation/freezed_annotation.dart';

part 'system_status_group.freezed.dart';

@freezed
abstract class SystemStatusGroup with _$SystemStatusGroup {
  const factory SystemStatusGroup({required String statusGroup, required String name}) = _SystemStatusGroup;
}
