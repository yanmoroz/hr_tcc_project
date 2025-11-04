import 'package:freezed_annotation/freezed_annotation.dart';
import 'discount_model.dart';

part 'discount_list_response.freezed.dart';
part 'discount_list_response.g.dart';

@freezed
abstract class DiscountListResponse with _$DiscountListResponse {
  const factory DiscountListResponse({required List<DiscountModel> discounts, required int total}) =
      _DiscountListResponse;

  factory DiscountListResponse.fromJson(Map<String, dynamic> json) => _$DiscountListResponseFromJson(json);
}
