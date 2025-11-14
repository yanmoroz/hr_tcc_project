import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/domain.dart';

part 'kp_parking_type_model.freezed.dart';
part 'kp_parking_type_model.g.dart';

@freezed
abstract class KpParkingTypeModel with _$KpParkingTypeModel {
  const factory KpParkingTypeModel({required String id, required String name}) = _KpParkingTypeModel;

  factory KpParkingTypeModel.fromJson(Map<String, dynamic> json) => _$KpParkingTypeModelFromJson(json);
}

extension KpParkingTypeModelX on KpParkingTypeModel {
  KpParkingType toDomain() {
    return KpParkingType(id: id, name: name);
  }
}
