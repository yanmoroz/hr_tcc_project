import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_trip_purpose.freezed.dart';

@freezed
abstract class BusinessTripPurpose with _$BusinessTripPurpose {
  const factory BusinessTripPurpose({required String id, required String name, required bool obligation}) =
      _BusinessTripPurpose;
}
