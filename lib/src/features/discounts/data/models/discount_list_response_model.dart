import 'package:freezed_annotation/freezed_annotation.dart';

import 'discount_model.dart';

part 'discount_list_response_model.freezed.dart';
part 'discount_list_response_model.g.dart';

@freezed
abstract class DiscountListResponseModel with _$DiscountListResponseModel {
  const factory DiscountListResponseModel({
    required List<DiscountModel> discounts,
    required int total,
  }) = _DiscountListResponseModel;

  factory DiscountListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DiscountListResponseModelFromJson(json);
}
