import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/domain.dart';

part 'kp_discount_category_model.freezed.dart';
part 'kp_discount_category_model.g.dart';

@freezed
abstract class KpDiscountCategoryModel with _$KpDiscountCategoryModel {
  const factory KpDiscountCategoryModel({
    required int code,
    required String name,
    int? discountSourceCode,
  }) = _KpDiscountCategoryModel;

  factory KpDiscountCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$KpDiscountCategoryModelFromJson(json);
}

extension KpDiscountCategoryModelX on KpDiscountCategoryModel {
  KpDiscountCategory toDomain() {
    return KpDiscountCategory(
      code: code,
      name: name,
      discountSourceCode: discountSourceCode,
    );
  }
}
