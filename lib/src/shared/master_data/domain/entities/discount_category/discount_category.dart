import 'package:freezed_annotation/freezed_annotation.dart';

part 'discount_category.freezed.dart';

@freezed
abstract class DiscountCategory with _$DiscountCategory {
  const factory DiscountCategory({
    required int code,
    required String name,
    int? discountSourceCode,
  }) = _DiscountCategory;
}
