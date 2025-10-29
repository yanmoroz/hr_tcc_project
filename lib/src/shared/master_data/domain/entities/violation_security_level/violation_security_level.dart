import 'package:freezed_annotation/freezed_annotation.dart';

part 'violation_security_level.freezed.dart';

@freezed
abstract class ViolationSecurityLevel with _$ViolationSecurityLevel {
  const factory ViolationSecurityLevel({
    required int code,
    required String name,
  }) = _ViolationSecurityLevel;
}
