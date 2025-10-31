import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'parking_type_model.freezed.dart';
part 'parking_type_model.g.dart';

@freezed
abstract class ParkingTypeModel with _$ParkingTypeModel {
  const factory ParkingTypeModel({required String id, required String name}) = _ParkingTypeModel;

  factory ParkingTypeModel.fromJson(Map<String, dynamic> json) => _$ParkingTypeModelFromJson(json);
}

extension ParkingTypeModelX on ParkingTypeModel {
  ParkingType toDomain() {
    return ParkingType(id: id, name: name);
  }
}
