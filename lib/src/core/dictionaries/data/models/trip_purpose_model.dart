import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../entities/trip_purpose.dart';

part 'trip_purpose_model.freezed.dart';
part 'trip_purpose_model.g.dart';

@freezed
abstract class TripPurposeModel with _$TripPurposeModel {
  const factory TripPurposeModel({
    required String id,
    required String code,
    required String name,
  }) = _TripPurposeModel;

  factory TripPurposeModel.fromJson(Map<String, dynamic> json) =>
      _$TripPurposeModelFromJson(json);
}

extension TripPurposeModelX on TripPurposeModel {
  TripPurpose toDomain() {
    return TripPurpose(id: id, code: code, name: name);
  }
}
