import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'system_status_model.freezed.dart';
part 'system_status_model.g.dart';

@freezed
abstract class SystemStatusModel with _$SystemStatusModel {
  const factory SystemStatusModel({
    required String id,
    required String idForm,
    required String statusGroup,
    required String code,
    required String name,
    required bool cancelable,
  }) = _SystemStatusModel;

  factory SystemStatusModel.fromJson(Map<String, dynamic> json) => _$SystemStatusModelFromJson(json);
}

extension SystemStatusModelX on SystemStatusModel {
  SystemStatus toDomain() {
    return SystemStatus(
      id: id,
      idForm: idForm,
      statusGroup: statusGroup,
      code: code,
      name: name,
      cancelable: cancelable,
    );
  }
}
