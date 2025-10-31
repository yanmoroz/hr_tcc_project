import 'package:freezed_annotation/freezed_annotation.dart';

part 'parking_type.freezed.dart';

@freezed
abstract class ParkingType with _$ParkingType {
  const factory ParkingType({required String id, required String name}) = _ParkingType;
}
