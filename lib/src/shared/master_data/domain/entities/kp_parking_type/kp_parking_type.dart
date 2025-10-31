import 'package:freezed_annotation/freezed_annotation.dart';

part 'kp_parking_type.freezed.dart';

@freezed
abstract class KpParkingType with _$KpParkingType {
  const factory KpParkingType({required String id, required String name}) = _KpParkingType;
}
