import 'package:freezed_annotation/freezed_annotation.dart';

part 'resell_equipment_type.freezed.dart';

@freezed
abstract class ResellEquipmentType with _$ResellEquipmentType {
  const factory ResellEquipmentType({required int code, required String name}) =
      _ResellEquipmentType;
}
