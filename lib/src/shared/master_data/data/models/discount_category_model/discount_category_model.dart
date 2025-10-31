import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/entities.dart';

part 'discount_category_model.freezed.dart';
part 'discount_category_model.g.dart';

@freezed
abstract class DiscountCategoryModel with _$DiscountCategoryModel {
  const factory DiscountCategoryModel({required int code, required String name, int? discountSourceCode}) =
      _DiscountCategoryModel;

  factory DiscountCategoryModel.fromJson(Map<String, dynamic> json) => _$DiscountCategoryModelFromJson(json);
}

extension DiscountCategoryModelX on DiscountCategoryModel {
  DiscountCategory toDomain() {
    return DiscountCategory(code: code, name: name, discountSourceCode: discountSourceCode);
  }
}
