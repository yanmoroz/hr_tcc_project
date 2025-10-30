import 'package:freezed_annotation/freezed_annotation.dart';

part 'trip_purpose.freezed.dart';

@freezed
abstract class TripPurpose with _$TripPurpose {
  const factory TripPurpose({required String id, required String code, required String name}) = _TripPurpose;
}
