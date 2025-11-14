import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';

part 'resell_equipment_type_model.freezed.dart';
part 'resell_equipment_type_model.g.dart';

@freezed
abstract class ResellEquipmentTypeModel with _$ResellEquipmentTypeModel {
  const factory ResellEquipmentTypeModel({required String id, required String name}) = _ResellEquipmentTypeModel;

  factory ResellEquipmentTypeModel.fromJson(Map<String, dynamic> json) => _$ResellEquipmentTypeModelFromJson(json);
}

extension ResellEquipmentTypeModelX on ResellEquipmentTypeModel {
  ResellEquipmentType toDomain() {
    return ResellEquipmentType(id: id, name: name);
  }
}
