import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'kp_discount_source_model.freezed.dart';
part 'kp_discount_source_model.g.dart';

@freezed
abstract class KpDiscountSourceModel with _$KpDiscountSourceModel {
  const factory KpDiscountSourceModel({
    required int code,
    required String name,
  }) = _KpDiscountSourceModel;

  factory KpDiscountSourceModel.fromJson(Map<String, dynamic> json) =>
      _$KpDiscountSourceModelFromJson(json);
}

extension KpDiscountSourceModelX on KpDiscountSourceModel {
  KpDiscountSource toDomain() {
    return KpDiscountSource(code: code, name: name);
  }
}
