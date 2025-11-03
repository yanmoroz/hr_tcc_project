import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'business_trip_purpose_model.freezed.dart';
part 'business_trip_purpose_model.g.dart';

@freezed
abstract class BusinessTripPurposeModel with _$BusinessTripPurposeModel {
  const factory BusinessTripPurposeModel({
    required String id,
    required String name,
    required bool obligation,
  }) = _BusinessTripPurposeModel;

  factory BusinessTripPurposeModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessTripPurposeModelFromJson(json);
}

extension BusinessTripPurposeModelX on BusinessTripPurposeModel {
  BusinessTripPurpose toDomain() {
    return BusinessTripPurpose(id: id, name: name, obligation: obligation);
  }
}

