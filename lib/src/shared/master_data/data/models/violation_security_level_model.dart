import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/violation_security_level/violation_security_level.dart';

part 'violation_security_level_model.freezed.dart';
part 'violation_security_level_model.g.dart';

@freezed
abstract class ViolationSecurityLevelModel with _$ViolationSecurityLevelModel {
  const factory ViolationSecurityLevelModel({required String id, required String name}) = _ViolationSecurityLevelModel;

  factory ViolationSecurityLevelModel.fromJson(Map<String, dynamic> json) =>
      _$ViolationSecurityLevelModelFromJson(json);
}

extension ViolationSecurityLevelModelX on ViolationSecurityLevelModel {
  ViolationSecurityLevel toDomain() {
    return ViolationSecurityLevel(id: id, name: name);
  }
}
