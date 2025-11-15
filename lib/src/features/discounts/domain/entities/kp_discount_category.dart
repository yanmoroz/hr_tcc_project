import 'package:freezed_annotation/freezed_annotation.dart';

part 'kp_discount_category.freezed.dart';

@freezed
abstract class KpDiscountCategory with _$KpDiscountCategory {
  const factory KpDiscountCategory({
    required int code,
    required String name,
    int? discountSourceCode,
  }) = _KpDiscountCategory;
}
